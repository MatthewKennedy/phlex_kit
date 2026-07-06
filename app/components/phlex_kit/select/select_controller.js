import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's phlex-kit--select controller. The ONE change from upstream:
// the @floating-ui/dom dependency is removed — the panel is positioned with plain
// CSS (.ui-select-content { position:absolute; top:100% }) instead of
// computePosition/autoUpdate, so this app needs no npm/build step. Everything else
// (open/close, item selection, keyboard nav, click-outside) is unchanged.
export default class extends Controller {
  static targets = ["trigger", "content", "input", "value", "item"];
  static values = { open: Boolean };
  static outlets = ["phlex-kit--select-item"];

  connect() {
    this.generateItemsIds();
  }

  selectItem(event) {
    event.preventDefault();

    this.phlexKitSelectItemOutlets.forEach((item) => item.handleSelectItem(event));

    const oldValue = this.inputTarget.value;
    const newValue = event.target.dataset.value;

    this.inputTarget.value = newValue;
    this.valueTarget.innerText = event.target.innerText;

    this.dispatchOnChange(oldValue, newValue);
    this.closeContent();
  }

  onClick() {
    this.toogleContent();

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

  handleEsc(event) {
    event.preventDefault();
    this.closeContent();
  }

  setFocusAndCurrent() {
    const selectedItem = this.itemTargets.find(
      (item) => item.getAttribute("aria-selected") === "true",
    );

    const focusItem = selectedItem || (this.hasItemTarget ? this.itemTarget : null);
    if (!focusItem) return; // empty select — nothing to focus

    focusItem.focus({ preventScroll: true });
    focusItem.setAttribute("aria-current", "true");
    this.triggerTarget.setAttribute("aria-activedescendant", focusItem.getAttribute("id"));
  }

  resetCurrent() {
    this.itemTargets.forEach((item) => item.removeAttribute("aria-current"));
  }

  clickOutside(event) {
    if (!this.openValue) return;
    if (this.element.contains(event.target)) return;

    event.preventDefault();
    this.toogleContent();
  }

  toogleContent() {
    this.openValue = !this.openValue;
    this.contentTarget.classList.toggle("hidden");
    this.triggerTarget.setAttribute("aria-expanded", this.openValue);
  }

  generateItemsIds() {
    const contentId = this.contentTarget.getAttribute("id");
    this.triggerTarget.setAttribute("aria-controls", contentId);

    this.itemTargets.forEach((item, index) => {
      item.id = `${contentId}-${index}`;
    });
  }

  setAriaCurrentAndActiveDescendant(currentIndex) {
    const currentItem = this.itemTargets[currentIndex];
    currentItem.focus({ preventScroll: true });
    currentItem.setAttribute("aria-current", "true");
    this.triggerTarget.setAttribute("aria-activedescendant", currentItem.getAttribute("id"));
  }

  closeContent() {
    this.toogleContent();
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
