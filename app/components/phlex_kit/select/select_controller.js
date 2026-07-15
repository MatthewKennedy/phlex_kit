import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's phlex-kit--select controller, minus the
// @floating-ui/dom dependency: the panel is a native [popover=manual] in the
// top layer, anchor-positioned with viewport-edge flipping by select.css
// (manual so this controller keeps owning open/close, item selection,
// keyboard nav, and click-outside — all unchanged from upstream).
export default class extends Controller {
  static targets = ["trigger", "content", "input", "value", "item"];
  static values = { open: Boolean };

  initialize() {
    // Stimulus fires [target]Connected before connect(): state used by
    // itemTargetConnected must be initialized here.
    this.itemIdCounter = 0;
  }

  // Per-item, not a connect()-time sweep: options injected later (Turbo
  // stream/frame) must still get ids or aria-activedescendant would point
  // at nothing — and a caller-provided id is left alone, not clobbered.
  itemTargetConnected(item) {
    if (!item.id) item.id = `${this.contentTarget.id}-${this.itemIdCounter++}`;
  }

  connect() {
    // A Turbo snapshot serializes aria-expanded / aria-activedescendant /
    // aria-current even though :popover-open does not survive the restore —
    // normalize here so a restored page doesn't announce an open listbox
    // over a closed select (same mitigation as dropdown_menu's connect).
    this.openValue = false;
    this.triggerTarget.setAttribute("aria-expanded", "false");
    this.triggerTarget.removeAttribute("aria-activedescendant");
    this.itemTargets.forEach((item) => item.removeAttribute("aria-current"));
    this.generateItemsIds();
  }

  selectItem(event) {
    event.preventDefault();

    // currentTarget, not target: the click may land on a child of the item
    // (target.dataset.value would be undefined). itemTargets, not a
    // document-scoped outlet: outlets match `.pk-select-item` page-wide and
    // clobbered every other Select's aria-selected.
    const item = event.currentTarget;
    // A malformed (hand-written) item without data-value must never submit
    // the literal string "undefined". SelectItem itself fails loud on nil.
    if (item.dataset.value === undefined) return;
    this.itemTargets.forEach((el) => {
      el.setAttribute("aria-selected", el === item ? "true" : "false");
    });

    const oldValue = this.inputTarget.value;
    const newValue = item.dataset.value;

    this.inputTarget.value = newValue;
    this.valueTarget.innerText = item.innerText;

    this.dispatchOnChange(oldValue, newValue);
    this.closeContent();
  }

  onClick() {
    this.toggleContent();

    if (this.openValue) {
      this.setFocusAndCurrent();
    } else {
      this.resetCurrent();
    }
  }

  handleKeyDown(event) {
    event.preventDefault();

    const currentIndex = this.itemTargets.findIndex(
      (item) => item.getAttribute("aria-current") === "true",
    );

    if (currentIndex + 1 < this.itemTargets.length) {
      // No aria-current yet (fresh open via keyboard) → start at the first item.
      if (currentIndex >= 0) this.itemTargets[currentIndex].removeAttribute("aria-current");
      this.setAriaCurrentAndActiveDescendant(currentIndex + 1);
    }
  }

  handleKeyUp(event) {
    event.preventDefault();

    const currentIndex = this.itemTargets.findIndex(
      (item) => item.getAttribute("aria-current") === "true",
    );

    if (currentIndex > 0) {
      this.itemTargets[currentIndex].removeAttribute("aria-current");
      this.setAriaCurrentAndActiveDescendant(currentIndex - 1);
    }
  }

  handleHome(event) {
    event.preventDefault();
    if (this.itemTargets.length === 0) return;
    this.resetCurrent();
    this.setAriaCurrentAndActiveDescendant(0);
  }

  handleEnd(event) {
    event.preventDefault();
    if (this.itemTargets.length === 0) return;
    this.resetCurrent();
    this.setAriaCurrentAndActiveDescendant(this.itemTargets.length - 1);
  }

  // Bound on the root as well as the items, so Escape also closes with focus
  // on the trigger; no-op while closed (a closed-state Escape must not steal
  // focus back to the trigger).
  handleEsc(event) {
    if (!this.contentTarget.matches(":popover-open")) return;
    event.preventDefault();
    this.closeContent();
  }

  setFocusAndCurrent() {
    const selectedItem = this.itemTargets.find(
      (item) => item.getAttribute("aria-selected") === "true",
    );

    const focusItem = selectedItem || (this.hasItemTarget ? this.itemTarget : null);
    if (!focusItem) return; // empty select — nothing to focus

    // preventScroll stops the page jumping when the top-layer panel opens;
    // scrollIntoView(nearest) then scrolls only the panel's own viewport so
    // the focused option is actually visible (max-height panel).
    focusItem.focus({ preventScroll: true });
    focusItem.scrollIntoView({ block: "nearest" });
    focusItem.setAttribute("aria-current", "true");
    this.triggerTarget.setAttribute("aria-activedescendant", focusItem.getAttribute("id"));
  }

  resetCurrent() {
    this.itemTargets.forEach((item) => item.removeAttribute("aria-current"));
  }

  clickOutside(event) {
    if (!this.contentTarget.matches(":popover-open")) return;
    if (this.element.contains(event.target)) return;

    event.preventDefault();
    this.#hide();
  }

  // Open/close derive from the live :popover-open state, never a stored
  // flag — a stale flag is how a close on an already-closed panel becomes
  // an open (bit the popover's keyboard toggle).
  toggleContent() {
    this.contentTarget.matches(":popover-open") ? this.#hide() : this.#show();
  }

  // Listbox typeahead: printable keys accumulate into a short-lived buffer
  // and move the highlight to the first option whose text starts with it.
  typeahead(event) {
    if (event.metaKey || event.ctrlKey || event.altKey) return;
    if (event.key.length !== 1 || event.key === " ") return; // Space selects
    clearTimeout(this.typeaheadTimer);
    this.typeaheadBuffer = (this.typeaheadBuffer || "") + event.key.toLowerCase();
    this.typeaheadTimer = setTimeout(() => { this.typeaheadBuffer = ""; }, 500);

    let index = this.itemTargets.findIndex((item) =>
      item.innerText.trim().toLowerCase().startsWith(this.typeaheadBuffer));
    if (index < 0) {
      // Buffer stopped matching — restart it from this keystroke (APG
      // typeahead: a failed prefix shouldn't dead-end until the timer clears).
      this.typeaheadBuffer = event.key.toLowerCase();
      index = this.itemTargets.findIndex((item) =>
        item.innerText.trim().toLowerCase().startsWith(this.typeaheadBuffer));
    }
    if (index < 0) return;
    this.resetCurrent();
    this.setAriaCurrentAndActiveDescendant(index);
  }

  disconnect() {
    clearTimeout(this.typeaheadTimer);
  }

  #show() {
    this.openValue = true;
    this.contentTarget.showPopover();
    this.triggerTarget.setAttribute("aria-expanded", "true");
  }

  #hide() {
    this.openValue = false;
    if (this.contentTarget.matches(":popover-open")) this.contentTarget.hidePopover();
    this.triggerTarget.setAttribute("aria-expanded", "false");
  }

  generateItemsIds() {
    const contentId = this.contentTarget.getAttribute("id");
    this.triggerTarget.setAttribute("aria-controls", contentId);
    // Name the listbox from the trigger (Radix wires it the same way) —
    // an unnamed role=listbox is announced as an anonymous list.
    if (!this.triggerTarget.id) this.triggerTarget.id = `${contentId}-trigger`;
    if (!this.contentTarget.hasAttribute("aria-labelledby")) {
      this.contentTarget.setAttribute("aria-labelledby", this.triggerTarget.id);
    }
  }

  setAriaCurrentAndActiveDescendant(currentIndex) {
    const currentItem = this.itemTargets[currentIndex];
    currentItem.focus({ preventScroll: true });
    // Keep the highlighted option visible inside the scrollable viewport —
    // preventScroll (page-jump guard) otherwise lets it scroll out of view.
    currentItem.scrollIntoView({ block: "nearest" });
    currentItem.setAttribute("aria-current", "true");
    this.triggerTarget.setAttribute("aria-activedescendant", currentItem.getAttribute("id"));
  }

  closeContent() {
    this.#hide();
    this.resetCurrent();

    // aria-activedescendant holds an element id; on close it must be removed,
    // not set to the literal string "true".
    this.triggerTarget.removeAttribute("aria-activedescendant");
    this.triggerTarget.focus({ preventScroll: true });
  }

  dispatchOnChange(oldValue, newValue) {
    if (oldValue === newValue) return;

    const event = new InputEvent("change", {
      bubbles: true,
      cancelable: true,
    });

    this.inputTarget.dispatchEvent(event);
  }
}
