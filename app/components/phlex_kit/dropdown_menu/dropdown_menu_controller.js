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
    // Outstanding syncSub rAF handles — cancelled on disconnect so a queued
    // frame never touches a torn-down menu (menubar's pattern).
    this.subFrames = new Set();
    // The visible control is the caller's button/link inside the trigger
    // wrapper — that's what AT reads, so the popup wiring belongs on it.
    this.invoker = this.triggerTarget.querySelector("button, a, [tabindex]") || this.triggerTarget;
    // A Turbo snapshot (or a detach/reattach that mimics one) serializes
    // aria-expanded="true" on sub triggers even though no submenu can be
    // open at connect time — sweep every stale marker back to false
    // (menubar's pattern). Runs before the invoker's own reset below so
    // both are covered by one mental model.
    this.element.querySelectorAll("[aria-expanded='true']").forEach((el) => el.setAttribute("aria-expanded", "false"));
    // Same shape for checkbox/radio rows: their `checked` DOM property
    // survives a reconnect but a hand-edited/replayed aria-checked can drift
    // from it — resync every row from its live input.
    this.element.querySelectorAll('input[type="checkbox"], input[type="radio"]').forEach((i) => {
      i.closest('[role^="menuitem"]')?.setAttribute("aria-checked", i.checked);
    });
    this.invoker.setAttribute("aria-haspopup", "menu");
    this.invoker.setAttribute("aria-expanded", "false");
    // Associate trigger and menu for AT (the dialog controller wires its
    // ids the same way).
    if (!this.contentTarget.id) this.contentTarget.id = `pk-dropdown-menu-${Math.random().toString(36).slice(2, 8)}`;
    this.invoker.setAttribute("aria-controls", this.contentTarget.id);
    // Turbo snapshots BEFORE disconnect — an open menu (reflected in the
    // open value) would be resurrected from the page cache on restore.
    this.boundBeforeCache = () => this.close();
    document.addEventListener("turbo:before-cache", this.boundBeforeCache);
    // `open:` on the Ruby side renders the value — start open (same
    // kwarg -> value -> connect flow as Collapsible).
    if (this.openValue) this.#open();
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.boundBeforeCache);
    this.subFrames.forEach((id) => cancelAnimationFrame(id));
    this.subFrames.clear();
    this.#removeEventListeners();
  }

  // Mirrors the CSS-driven submenu state (:hover / :focus-within) onto the
  // sub trigger's aria-expanded. rAF: on mouseleave/focusout the pseudo-class
  // state isn't settled until the event finishes dispatching.
  syncSub(e) {
    const sub = e.currentTarget;
    const id = requestAnimationFrame(() => {
      this.subFrames.delete(id);
      sub.querySelector(":scope > [aria-haspopup]")
        ?.setAttribute("aria-expanded", sub.matches(":hover, :focus-within"));
    });
    this.subFrames.add(id);
  }

  onClickOutside(event) {
    // Gate on the live :popover-open state, not the stored flag — a stale
    // flag is how a close on an already-closed panel becomes an open.
    if (!this.contentTarget.matches(":popover-open")) return;
    if (this.element.contains(event.target)) return;

    // Deliberate (matches Radix's modal dismiss): the outside click ONLY
    // dismisses the menu — it is swallowed rather than also acting on
    // whatever was under the pointer (e.g. navigating a link).
    event.preventDefault();
    this.close();
  }

  toggle() {
    this.contentTarget.matches(":popover-open") ? this.close() : this.#open();
  }

  // Tabbing (or otherwise moving real focus) out of the menu closes it —
  // menubar's onFocusout pattern (menubar_controller.js). relatedTarget is
  // null when the window itself blurs — leave the menu alone then. The
  // trigger + content are both DOM children of this.element even though the
  // content is a top-layer popover, so one containment check covers both.
  onFocusout(e) {
    if (!this.contentTarget.matches(":popover-open")) return;
    const to = e.relatedTarget;
    if (!to || this.element.contains(to)) return;
    this.close();
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
    // This listener is document-level (see #addEventListeners) so it keeps
    // receiving events even once real focus has left the menu (e.g. a click
    // into an unrelated text field the onFocusout listener didn't catch) —
    // scope the roving-nav keys to when focus is actually within the widget.
    // this.element (not just contentTarget) so ArrowDown still works right
    // after a mouse-driven open, when focus is still on the invoker button
    // (#open() doesn't force focus into the first row). Escape stays global
    // while the menu is open (APG).
    if (e.key !== "Escape" && !this.element.contains(document.activeElement)) return;

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
      case "ArrowRight":
        // On a sub trigger, enter the submenu (focus reveals it via
        // :focus-within, making its rows visible to the roving nav).
        // Same keyboard grammar as context_menu.
        if (document.activeElement?.matches(".pk-dropdown-menu-sub-trigger")) {
          e.preventDefault();
          this.#enterSub(document.activeElement);
        }
        break;
      case "ArrowLeft": {
        // Inside a submenu, step back to its trigger (closes it on focus-out).
        const sub = document.activeElement?.closest(".pk-dropdown-menu-sub-content");
        if (sub) {
          e.preventDefault();
          sub.closest(".pk-dropdown-menu-sub")?.querySelector(".pk-dropdown-menu-sub-trigger")?.focus();
        }
        break;
      }
    }
  }

  #enterSub(trigger) {
    trigger.focus();
    const panel = trigger.closest(".pk-dropdown-menu-sub")?.querySelector(".pk-dropdown-menu-sub-content");
    if (!panel) return;
    const first = [...panel.querySelectorAll('[role^="menuitem"]')]
      .find((el) => !el.closest("[data-disabled]") && el.getClientRects().length > 0);
    first?.focus();
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
