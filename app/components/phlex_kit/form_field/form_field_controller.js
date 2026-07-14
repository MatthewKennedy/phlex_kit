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
      if (this.errorTarget.textContent) {
        this.shouldValidateValue = true;
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
    this.#setErrorMessage();
  }

  onInput() {
    this.#setErrorMessage();
  }

  onChange() {
    this.#setErrorMessage();
  }

  #setErrorMessage() {
    if (!this.shouldValidateValue || !this.hasErrorTarget) return;

    // aria-invalid drives the red ring for LIVE validation too (input.css
    // only matched server-rendered attrs); aria-describedby ties the message
    // to the control for AT.
    if (this.errorTarget.id) {
      this.inputTarget.setAttribute("aria-describedby", this.errorTarget.id);
    }
    if (this.inputTarget.validity.valid) {
      this.inputTarget.removeAttribute("aria-invalid");
      this.errorTarget.textContent = "";
      this.errorTarget.classList.add("pk-hidden");
    } else {
      this.inputTarget.setAttribute("aria-invalid", "true");
      this.errorTarget.textContent = this.#getValidationMessage();
      this.errorTarget.classList.remove("pk-hidden");
    }
  }

  #getValidationMessage() {
    let errorMessage;

    const { validity, dataset, validationMessage } = this.inputTarget;

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
