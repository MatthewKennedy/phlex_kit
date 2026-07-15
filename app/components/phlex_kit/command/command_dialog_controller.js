import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's command-dialog controller (Stimulus-only upstream),
// identifiers renamed ruby-ui → phlex-kit and the Tailwind body scroll-lock
// class swapped for inline overflow (matching the shipped dialog). Unlike
// upstream's document-scoped outlet (which let one dialog adopt another's
// open palette), each instance tracks its own clone — sheet_controller's
// pattern — and clears it on turbo:before-cache so a cached page never
// restores a stale overlay + scroll lock. While the overlay is up, the page
// behind it is inert-ed per element with prior state saved (the same modal
// contract as alert_dialog/sheet/sidebar — the helper is duplicated per
// controller by design); restore runs on dismiss (via the overlay's
// phlex-kit--command:dismiss event), disconnect, AND turbo:before-cache.
// Connects to data-controller="phlex-kit--command-dialog"
export default class extends Controller {
  static targets = ["content"];

  initialize() {
    this.overlay = null;
    this.inerted = null;
    // The command controller's dismiss() dispatches this on the overlay
    // BEFORE it removes the clone / restores focus — un-inert first so the
    // opener is focusable again.
    this.restoreInert = () => {
      for (const [el, wasInert] of this.inerted || []) el.inert = wasInert;
      this.inerted = null;
    };
    this.clearOverlay = () => {
      this.restoreInert();
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
    this.overlay.addEventListener("phlex-kit--command:dismiss", this.restoreInert);
    // prevent scroll on body
    document.body.style.overflow = "hidden";
    this.#inertOthers();
  }

  // Make everything behind the overlay inert (the clone is <body>'s last
  // child, so its siblings are the whole page). Prior inert state is saved
  // per element and restored by restoreInert. The command controller's Tab
  // trap on the clone stays as belt and braces.
  #inertOthers() {
    this.inerted = [];
    for (const el of document.body.children) {
      if (el === this.overlay) continue;
      if (["SCRIPT", "STYLE", "LINK", "TEMPLATE"].includes(el.tagName)) continue;
      this.inerted.push([el, el.inert]);
      el.inert = true;
    }
  }
}
