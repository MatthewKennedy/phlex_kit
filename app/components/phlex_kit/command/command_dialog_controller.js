import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's command-dialog controller (Stimulus-only upstream),
// identifiers renamed ruby-ui → phlex-kit and the Tailwind body scroll-lock
// class swapped for inline overflow (matching the shipped dialog).
// Connects to data-controller="phlex-kit--command-dialog"
export default class extends Controller {
  static targets = ["content"];
  static outlets = ["phlex-kit--command"];

  phlexKitCommandOutletConnected(controller) {
    this.openOutlet = controller;
  }

  phlexKitCommandOutletDisconnected() {
    this.openOutlet = null;
  }

  open(e) {
    if (e) {
      e.preventDefault();
    }

    if (!this.hasContentTarget) {
      return;
    }

    if (this.openOutlet) {
      this.openOutlet.focusInput();
      return;
    }

    document.body.insertAdjacentHTML("beforeend", this.contentTarget.innerHTML);
    // prevent scroll on body
    document.body.style.overflow = "hidden";
  }
}
