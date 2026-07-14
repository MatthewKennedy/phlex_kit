import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's command-dialog controller (Stimulus-only upstream),
// identifiers renamed ruby-ui → phlex-kit and the Tailwind body scroll-lock
// class swapped for inline overflow (matching the shipped dialog). Unlike
// upstream's document-scoped outlet (which let one dialog adopt another's
// open palette), each instance tracks its own clone — sheet_controller's
// pattern — and clears it on turbo:before-cache so a cached page never
// restores a stale overlay + scroll lock.
// Connects to data-controller="phlex-kit--command-dialog"
export default class extends Controller {
  static targets = ["content"];

  initialize() {
    this.overlay = null;
    this.clearOverlay = () => {
      if (this.overlay?.isConnected) {
        this.overlay.remove();
        document.body.style.removeProperty("overflow");
      }
      this.overlay = null;
    };
  }

  connect() {
    document.addEventListener("turbo:before-cache", this.clearOverlay);
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.clearOverlay);
    this.clearOverlay();
  }

  open(e) {
    if (e) {
      e.preventDefault();
    }

    if (!this.hasContentTarget) {
      return;
    }

    // Already open (the command controller's dismiss may have removed the
    // clone behind our back — isConnected catches that): just refocus.
    if (this.overlay?.isConnected) {
      this.overlay.querySelector("[data-phlex-kit--command-target='input']")?.focus();
      return;
    }

    document.body.insertAdjacentHTML("beforeend", this.contentTarget.innerHTML);
    this.overlay = document.body.lastElementChild;
    // prevent scroll on body
    document.body.style.overflow = "hidden";
  }
}
