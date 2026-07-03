import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's phlex-kit--alert-dialog controller. open() clones the
// <template> content into <body> as a modal (the clone carries its own instance
// of this controller); dismiss() removes it. The only change from upstream: lock
// body scroll via inline style rather than a Tailwind `overflow-hidden` class.
export default class extends Controller {
  static targets = ["content"];
  static values = { open: { type: Boolean, default: false } };

  connect() {
    if (this.openValue) this.open();
  }

  open() {
    document.body.insertAdjacentHTML("beforeend", this.contentTarget.innerHTML);
    document.body.style.overflow = "hidden";
  }

  dismiss() {
    document.body.style.overflow = "";
    this.element.remove();
  }
}
