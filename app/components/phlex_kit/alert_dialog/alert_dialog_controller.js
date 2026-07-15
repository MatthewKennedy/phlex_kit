import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's phlex-kit--alert-dialog controller. open() clones the
// <template> content into <body> as a modal; the clone carries its own
// instance of this controller, which owns the full modal contract for the
// clone's lifetime (mirroring sheet_content_controller): scroll lock, initial
// focus (the Cancel action when present — APG wants the least destructive
// control), Tab focus trap, Escape-to-dismiss, focus restore to the opener,
// background inert, and aria-labelledby/-describedby wiring to
// Title/Description. Escape/Tab are handled by a document-level keydown
// listener (an element-scoped one dies the moment focus escapes to <body>);
// the overlay's mousedown guard keeps focus from leaving the trap. connect and
// disconnect exactly bracket the clone, so removal by any path (Cancel,
// Escape, turbo:before-cache) restores state.
const FOCUSABLE =
  'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';

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
    this.onKeydown = (event) => this.keydown(event);
    // Turbo snapshots synchronously right after dispatching this event —
    // BEFORE Stimulus disconnect() runs (it fires via MutationObserver, too
    // late). Restore inert + scroll lock here so the snapshot never captures
    // a fully-inerted, scroll-locked page; disconnect()'s later restore
    // becomes a harmless no-op (#restoreInert clears `this.inerted`, and
    // reassigning the same overflow value is idempotent).
    this.beforeCache = () => {
      this.#restoreInert();
      document.body.style.overflow = this.previousOverflow;
      this.element.remove();
    };
    document.addEventListener("keydown", this.onKeydown);
    document.addEventListener("turbo:before-cache", this.beforeCache);
    this.#inertOthers();
    this.#wireAria();
    const focusables = this.#focusables();
    const cancel = focusables.find((el) => (el.dataset.action || "").includes("#dismiss"));
    (cancel || focusables[0] || this.#panel())?.focus();
  }

  disconnect() {
    if (this.hasContentTarget) return;
    document.removeEventListener("keydown", this.onKeydown);
    document.removeEventListener("turbo:before-cache", this.beforeCache);
    this.#restoreInert();
    document.body.style.overflow = this.previousOverflow;
    if (this.opener?.isConnected) this.opener.focus();
  }

  open() {
    // Double-open guard: Enter+click (or a double-click) on the trigger must
    // not stack a second clone over the first.
    if (this.clone?.isConnected) return;
    // open: is one-shot — the reflected value sits in the Turbo snapshot, so
    // a cache-restored reconnect would re-open a dialog the user dismissed.
    this.openValue = false;
    document.body.insertAdjacentHTML("beforeend", this.contentTarget.innerHTML);
    this.clone = document.body.lastElementChild;
  }

  dismiss() {
    this.element.remove();
  }

  // Overlay mousedown would move focus to <body>, killing an element-scoped
  // trap; prevented here so focus stays inside the panel (the overlay is
  // deliberately NOT a dismiss surface on an alert dialog).
  overlayMousedown(event) {
    event.preventDefault();
  }

  keydown(event) {
    // Every open clone has its own document-level listener; with stacked
    // alert dialogs (a trigger inside a panel) only the topmost clone may
    // handle the keyboard, or one Escape would close every layer at once.
    if (!this.#topmost()) return;
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
    // Focus somehow left the dialog (e.g. programmatically): pull it back in.
    if (!this.element.contains(document.activeElement)) {
      event.preventDefault();
      focusables[0].focus();
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

  // Clones are appended as direct <body> children whose direct child is the
  // [role="alertdialog"] panel (source elements only hold a <template>, whose
  // content never matches querySelector). The last such clone is the topmost.
  #topmost() {
    const clones = document.body.querySelectorAll(':scope > [data-controller~="phlex-kit--alert-dialog"] > [role="alertdialog"]');
    return clones.length > 0 && clones[clones.length - 1].parentElement === this.element;
  }

  #panel() {
    return this.element.querySelector('[role="alertdialog"]');
  }

  #focusables() {
    const panel = this.#panel();
    if (!panel) return [];
    return [...panel.querySelectorAll(FOCUSABLE)].filter((el) => el.getClientRects().length > 0);
  }

  // Make everything behind the modal inert (the clone is <body>'s last child,
  // so its siblings are the whole page). Prior inert state is saved per
  // element and restored on disconnect.
  #inertOthers() {
    this.inerted = [];
    for (const el of document.body.children) {
      if (el === this.element) continue;
      if (["SCRIPT", "STYLE", "LINK", "TEMPLATE"].includes(el.tagName)) continue;
      this.inerted.push([el, el.inert]);
      el.inert = true;
    }
  }

  #restoreInert() {
    for (const [el, wasInert] of this.inerted || []) el.inert = wasInert;
    this.inerted = null;
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
