import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's form-field controller (Stimulus-only upstream),
// identifiers renamed ruby-ui → phlex-kit and the Tailwind hidden class swapped
// for .pk-hidden. Validation stays quiet until the control first goes invalid
// (or the error target renders with server content); after that the message
// live-updates on every input/change. Per-constraint messages come from
// data-* on the input (data-value-missing, data-type-mismatch, …), falling
// back to the browser's validationMessage.
// Connects to data-controller="phlex-kit--form-field"
export default class extends Controller {
  static targets = ["input", "error", "hint"];
  static values = { shouldValidate: false };

  connect() {
    // Hints are static description text — wire them onto every control's
    // aria-describedby up front (errors join/leave dynamically via
    // #describeBy, which preserves foreign tokens like these).
    this.hintTargets.forEach((hint) => {
      if (!hint.id) return;
      this.inputTargets.forEach((input) => {
        const tokens = (input.getAttribute("aria-describedby") || "").split(/\s+/).filter(Boolean);
        if (!tokens.includes(hint.id)) tokens.push(hint.id);
        input.setAttribute("aria-describedby", tokens.join(" "));
      });
    });
    if (this.hasErrorTarget) {
      if (this.errorTarget.textContent.trim()) {
        this.shouldValidateValue = true;
        // A server-rendered error is already visible — give the control(s)
        // the same aria wiring onInvalid applies, instead of leaving
        // aria-invalid/aria-describedby unset until the first input/change.
        this.inputTargets.forEach((input) => {
          input.setAttribute("aria-invalid", "true");
          this.#describeBy(input, true);
        });
      } else {
        this.errorTarget.classList.add("pk-hidden");
      }
    }
  }

  onInvalid(error) {
    // Only suppress the native validation bubble when we can show our own
    // message — a FormField without a FormFieldError previously ate the
    // bubble AND crashed on the missing target, so a required-but-empty
    // form gave zero feedback and never submitted.
    if (!this.hasErrorTarget) return;
    error.preventDefault();

    // preventDefault also cancels the browser's focus-first-invalid — restore
    // it for the first invalid control of the submit pass (all invalid events
    // fire in the same task, so the microtask reset scopes "first" correctly).
    if (!this._focusedInvalid) {
      this._focusedInvalid = true;
      queueMicrotask(() => { this._focusedInvalid = false; });
      error.target.focus({ preventScroll: true });
      error.target.scrollIntoView({ block: "nearest" });
    }

    this.shouldValidateValue = true;
    this.#setErrorMessage();
  }

  onInput(_event) {
    this.#setErrorMessage();
  }

  onChange(_event) {
    this.#setErrorMessage();
  }

  // A FormField can carry several input targets (radio/checkbox groups, or
  // independent controls like two required checkboxes sharing one error).
  // Recompute across ALL of them on every validity event — deciding from the
  // event's own target alone left a shared error stuck on/off based on
  // whichever control happened to fire last, out of step with the others'
  // own (correctly-updated) aria-invalid.
  #setErrorMessage() {
    if (!this.shouldValidateValue || !this.hasErrorTarget) return;

    // aria-invalid drives the red ring for LIVE validation too (input.css
    // only matched server-rendered attrs); each control reflects its own
    // validity regardless of which one fired the event. Radio buttons
    // sharing a `name` share native validity, so they naturally agree here.
    let firstInvalid = null;
    this.inputTargets.forEach((input) => {
      if (input.validity.valid) {
        input.removeAttribute("aria-invalid");
      } else {
        input.setAttribute("aria-invalid", "true");
        firstInvalid ||= input;
      }
      // Clear the shared error's id everywhere first — it's re-added below,
      // only on the one control whose message is currently shown.
      this.#describeBy(input, false);
    });

    if (firstInvalid) {
      this.#describeBy(firstInvalid, true);
      this.errorTarget.textContent = this.#getValidationMessage(firstInvalid);
      this.errorTarget.classList.remove("pk-hidden");
    } else {
      this.errorTarget.textContent = "";
      this.errorTarget.classList.add("pk-hidden");
    }
  }

  // Append/remove the error's id on the control's aria-describedby without
  // clobbering pre-existing tokens (e.g. a hint's id).
  #describeBy(input, present) {
    const id = this.errorTarget.id;
    if (!id) return;
    const tokens = (input.getAttribute("aria-describedby") || "").split(/\s+/).filter((t) => t && t !== id);
    if (present) tokens.push(id);
    if (tokens.length) input.setAttribute("aria-describedby", tokens.join(" "));
    else input.removeAttribute("aria-describedby");
  }

  #getValidationMessage(input) {
    let errorMessage;

    const { validity, dataset, validationMessage } = input;

    if (validity.tooLong) errorMessage = dataset.tooLong;
    if (validity.tooShort) errorMessage = dataset.tooShort;
    if (validity.badInput) errorMessage = dataset.badInput;
    if (validity.typeMismatch) errorMessage = dataset.typeMismatch;
    if (validity.stepMismatch) errorMessage = dataset.stepMismatch;
    if (validity.valueMissing) errorMessage = dataset.valueMissing;
    if (validity.rangeOverflow) errorMessage = dataset.rangeOverflow;
    if (validity.rangeUnderflow) errorMessage = dataset.rangeUnderflow;
    if (validity.patternMismatch) errorMessage = dataset.patternMismatch;

    return errorMessage || validationMessage;
  }
}
