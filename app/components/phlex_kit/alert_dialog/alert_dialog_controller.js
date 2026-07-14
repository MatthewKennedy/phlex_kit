import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's phlex-kit--alert-dialog controller. open() clones the
// <template> content into <body> as a modal; the clone carries its own
// instance of this controller, which owns the full modal contract for the
// clone's lifetime (mirroring sheet_content_controller): scroll lock, initial
// focus (the Cancel action when present — APG wants the least destructive
// control), Tab focus trap, Escape-to-dismiss, focus restore to the opener,
// and aria-labelledby/-describedby wiring to Title/Description. connect and
// disconnect exactly bracket the clone, so removal by any path restores state.
const FOCUSABLE =
  'a[href], button:not([disabled]), input:not([disabled]), select, textarea, [tabindex]:not([tabindex="-1"])';

export default class extends Controller {
  static targets = ["content"];
  static values = { open: { type: Boolean, default: false } };

  connect() {
    // The source element holds the <template>; the clone in <body> does not.
    if (this.hasContentTarget) {
      if (this.openValue) this.open();
      return;
    }
    this.opener = document.activeElement;
    this.previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    this.#wireAria();
    const focusables = this.#focusables();
    const cancel = focusables.find((el) => (el.dataset.action || "").includes("#dismiss"));
    (cancel || focusables[0] || this.#panel())?.focus();
  }

  disconnect() {
    if (this.hasContentTarget) return;
    document.body.style.overflow = this.previousOverflow;
    if (this.opener?.isConnected) this.opener.focus();
  }

  open() {
    // Double-open guard: Enter+click (or a double-click) on the trigger must
    // not stack a second clone over the first.
    if (this.clone?.isConnected) return;
    document.body.insertAdjacentHTML("beforeend", this.contentTarget.innerHTML);
    this.clone = document.body.lastElementChild;
  }

  dismiss() {
    this.element.remove();
  }

  keydown(event) {
    if (event.key === "Escape") {
      event.preventDefault();
      this.dismiss();
      return;
    }
    if (event.key !== "Tab") return;
    const focusables = this.#focusables();
    if (focusables.length === 0) {
      event.preventDefault();
      this.#panel()?.focus();
      return;
    }
    const first = focusables[0];
    const last = focusables[focusables.length - 1];
    if (event.shiftKey && (document.activeElement === first || document.activeElement === this.#panel())) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first.focus();
    }
  }

  #panel() {
    return this.element.querySelector('[role="alertdialog"]');
  }

  #focusables() {
    const panel = this.#panel();
    if (!panel) return [];
    return [...panel.querySelectorAll(FOCUSABLE)].filter((el) => el.getClientRects().length > 0);
  }

  #wireAria() {
    const panel = this.#panel();
    if (!panel) return;
    const wire = (attr, selector) => {
      if (panel.getAttribute(attr)) return;
      const el = this.element.querySelector(selector);
      if (!el) return;
      if (!el.id) el.id = `pk-alert-dialog-${Math.random().toString(36).slice(2, 10)}`;
      panel.setAttribute(attr, el.id);
    };
    wire("aria-labelledby", ".pk-alert-dialog-title");
    wire("aria-describedby", ".pk-alert-dialog-description");
  }
}
