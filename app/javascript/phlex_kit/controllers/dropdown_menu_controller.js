import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's phlex-kit--dropdown-menu controller. The ONE change from
// upstream: the @floating-ui/dom dependency is removed — the panel is positioned
// with plain CSS (.ui-dropdown-menu-content { position:absolute }), so this app
// needs no npm/build step. Toggle, click-outside, and arrow/enter keyboard nav
// are unchanged.
export default class extends Controller {
  static targets = ["trigger", "content", "menuItem"];
  static values = { open: { type: Boolean, default: false } };

  connect() {
    this.boundHandleKeydown = this.#handleKeydown.bind(this);
    this.selectedIndex = -1;
  }

  disconnect() {
    this.#removeEventListeners();
  }

  onClickOutside(event) {
    if (!this.openValue) return;
    if (this.element.contains(event.target)) return;

    event.preventDefault();
    this.close();
  }

  toggle() {
    this.contentTarget.classList.contains("hidden") ? this.#open() : this.close();
  }

  #open() {
    this.openValue = true;
    this.#deselectAll();
    this.#addEventListeners();
    // Lift the open menu above siblings (the container has no static z-index).
    this.element.style.zIndex = "50";
    this.contentTarget.classList.remove("hidden");
  }

  close() {
    this.openValue = false;
    this.#removeEventListeners();
    this.element.style.zIndex = "";
    this.contentTarget.classList.add("hidden");
  }

  #handleKeydown(e) {
    if (this.menuItemTargets.length === 0) return;

    if (e.key === "ArrowDown") {
      e.preventDefault();
      this.#updateSelectedItem(1);
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      this.#updateSelectedItem(-1);
    } else if (e.key === "Enter" && this.selectedIndex !== -1) {
      e.preventDefault();
      this.menuItemTargets[this.selectedIndex].click();
    } else if (e.key === "Escape") {
      this.close();
    }
  }

  #updateSelectedItem(direction) {
    this.menuItemTargets.forEach((item, index) => {
      if (item.getAttribute("aria-selected") === "true") this.selectedIndex = index;
    });

    if (this.selectedIndex >= 0) {
      this.#toggleAriaSelected(this.menuItemTargets[this.selectedIndex], false);
    }

    this.selectedIndex += direction;

    if (this.selectedIndex < 0) {
      this.selectedIndex = this.menuItemTargets.length - 1;
    } else if (this.selectedIndex >= this.menuItemTargets.length) {
      this.selectedIndex = 0;
    }

    this.#toggleAriaSelected(this.menuItemTargets[this.selectedIndex], true);
  }

  #toggleAriaSelected(element, isSelected) {
    if (isSelected) {
      element.setAttribute("aria-selected", "true");
    } else {
      element.removeAttribute("aria-selected");
    }
  }

  #deselectAll() {
    this.menuItemTargets.forEach((item) => this.#toggleAriaSelected(item, false));
    this.selectedIndex = -1;
  }

  #addEventListeners() {
    document.addEventListener("keydown", this.boundHandleKeydown);
  }

  #removeEventListeners() {
    document.removeEventListener("keydown", this.boundHandleKeydown);
  }
}
