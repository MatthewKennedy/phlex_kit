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
    if (!this.shouldValidateValue) return;

    if (this.inputTarget.validity.valid) {
      this.errorTarget.textContent = "";
      this.errorTarget.classList.add("pk-hidden");
    } else {
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
