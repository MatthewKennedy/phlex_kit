import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's phlex-kit--dropdown-menu controller, minus the
// @floating-ui/dom dependency: the panel is a native [popover=manual] in the
// top layer, anchor-positioned with viewport-edge flipping by
// dropdown_menu.css (manual so this controller keeps owning click-outside,
// Escape, and keyboard nav). Keyboard nav moves REAL focus over the rows
// (upstream stamped aria-selected on menuitems, which AT ignores): :focus
// styles the highlight and :focus-within opens/closes submenus, so hidden
// sub-rows are skipped via a visibility filter. Escape returns focus to the
// trigger; Enter/Space activate the focused row (links, checkbox/radio
// labels, and sub triggers alike).
export default class extends Controller {
  static targets = ["trigger", "content", "menuItem"];
  static values = { open: { type: Boolean, default: false } };

  connect() {
    this.boundHandleKeydown = this.#handleKeydown.bind(this);
    // The visible control is the caller's button/link inside the trigger
    // wrapper — that's what AT reads, so the popup wiring belongs on it.
    this.invoker = this.triggerTarget.querySelector("button, a, [tabindex]") || this.triggerTarget;
    this.invoker.setAttribute("aria-haspopup", "menu");
    this.invoker.setAttribute("aria-expanded", "false");
  }

  disconnect() {
    this.#removeEventListeners();
  }

  onClickOutside(event) {
    // Gate on the live :popover-open state, not the stored flag — a stale
    // flag is how a close on an already-closed panel becomes an open.
    if (!this.contentTarget.matches(":popover-open")) return;
    if (this.element.contains(event.target)) return;

    event.preventDefault();
    this.close();
  }

  toggle() {
    this.contentTarget.matches(":popover-open") ? this.close() : this.#open();
  }

  #open() {
    this.openValue = true;
    this.#addEventListeners();
    this.contentTarget.showPopover();
    this.invoker.setAttribute("aria-expanded", "true");
  }

  close(event) {
    // Menu rows default to href="#"; without this an Enter/click on a
    // non-link row scrolls to top and appends # to the URL.
    if (event?.target?.closest?.('a[href="#"]')) event.preventDefault();
    this.openValue = false;
    this.#removeEventListeners();
    if (this.contentTarget.matches(":popover-open")) this.contentTarget.hidePopover();
    this.invoker.setAttribute("aria-expanded", "false");
  }

  // Mirrors a checkbox/radio row's native input state onto the row's
  // aria-checked (radios also reset their group's siblings).
  syncChecked(event) {
    const input = event.target;
    const group = input.name
      ? this.element.querySelectorAll(`input[name="${CSS.escape(input.name)}"]`)
      : [input];
    group.forEach((i) => i.closest('[role^="menuitem"]')?.setAttribute("aria-checked", i.checked));
  }

  #handleKeydown(e) {
    const items = this.#items();
    if (items.length === 0) return;
    const index = items.indexOf(document.activeElement);

    switch (e.key) {
      case "ArrowDown":
        e.preventDefault();
        items[(index + 1) % items.length]?.focus();
        break;
      case "ArrowUp":
        e.preventDefault();
        items[index < 0 ? items.length - 1 : (index - 1 + items.length) % items.length]?.focus();
        break;
      case "Home":
        e.preventDefault();
        items[0]?.focus();
        break;
      case "End":
        e.preventDefault();
        items[items.length - 1]?.focus();
        break;
      case "Enter":
      case " ":
        // Explicit click so label rows (checkbox/radio) activate too —
        // labels have no native keyboard activation.
        if (index >= 0) {
          e.preventDefault();
          items[index].click();
        }
        break;
      case "Escape":
        e.preventDefault();
        this.close();
        this.invoker.focus();
        break;
    }
  }

  // Rows inside a closed submenu are display:none (revealed by CSS on
  // hover/focus-within) — focus() on them silently fails and the roving
  // navigation would jam at the submenu boundary.
  #items() {
    return this.menuItemTargets.filter(
      (el) => !el.closest("[data-disabled]") && el.getClientRects().length > 0,
    );
  }

  #addEventListeners() {
    document.addEventListener("keydown", this.boundHandleKeydown);
  }

  #removeEventListeners() {
    document.removeEventListener("keydown", this.boundHandleKeydown);
  }
}
