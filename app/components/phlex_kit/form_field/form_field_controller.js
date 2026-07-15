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
  static targets = ["input", "error"];
  static values = { shouldValidate: false };

  connect() {
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

    this.shouldValidateValue = true;
    this.#setErrorMessage(error);
  }

  onInput(event) {
    this.#setErrorMessage(event);
  }

  onChange(event) {
    this.#setErrorMessage(event);
  }

  // The event's own control, when it's one of ours — radio/checkbox groups
  // register several input targets and validity/aria-invalid must land on
  // the control that fired, not always the first.
  #inputFor(event) {
    if (event && this.inputTargets.includes(event.target)) return event.target;
    return this.inputTarget;
  }

  #setErrorMessage(event) {
    if (!this.shouldValidateValue || !this.hasErrorTarget) return;

    const input = this.#inputFor(event);
    // aria-invalid drives the red ring for LIVE validation too (input.css
    // only matched server-rendered attrs); aria-describedby ties the message
    // to the control for AT.
    if (input.validity.valid) {
      input.removeAttribute("aria-invalid");
      this.#describeBy(input, false);
      this.errorTarget.textContent = "";
      this.errorTarget.classList.add("pk-hidden");
    } else {
      input.setAttribute("aria-invalid", "true");
      this.#describeBy(input, true);
      this.errorTarget.textContent = this.#getValidationMessage(input);
      this.errorTarget.classList.remove("pk-hidden");
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
