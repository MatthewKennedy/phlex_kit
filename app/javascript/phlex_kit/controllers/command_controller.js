import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's command controller. TWO changes from upstream: the
// fuse.js dependency is replaced with a dependency-free substring match over
// each item's data-value, and show/hide + body scroll-lock use .pk-hidden /
// inline overflow (matching the shipped dialog) instead of Tailwind utility
// classes. Everything else (filtering, keyboard nav, dismiss) is unchanged.
// Connects to data-controller="phlex-kit--command"
export default class extends Controller {
  static targets = ["input", "group", "item", "empty"];

  connect() {
    this.selectedIndex = -1;

    if (!this.hasInputTarget) {
      return;
    }

    this.inputTarget.focus();
    this.searchIndex = this.buildSearchIndex();
    this.toggleVisibility(this.emptyTargets, false);
  }

  dismiss() {
    // allow scroll on body
    document.body.style.removeProperty("overflow");
    // remove the element
    this.element.remove();
  }

  focusInput() {
    this.inputTarget?.focus();
  }

  filter(e) {
    // Deselect any previously selected item
    this.deselectAll();

    const query = e.target.value.toLowerCase();
    if (query.length === 0) {
      this.resetVisibility();
      return;
    }

    this.toggleVisibility(this.itemTargets, false);

    const results = this.searchIndex.search(query);
    results.forEach((result) =>
      this.toggleVisibility([result.item.element], true),
    );

    this.toggleVisibility(this.emptyTargets, results.length === 0);
    this.updateGroupVisibility();
  }

  toggleVisibility(elements, isVisible) {
    elements.forEach((el) => el.classList.toggle("pk-hidden", !isVisible));
  }

  updateGroupVisibility() {
    this.groupTargets.forEach((group) => {
      const hasVisibleItems =
        group.querySelectorAll(
          "[data-phlex-kit--command-target='item']:not(.pk-hidden)",
        ).length > 0;
      this.toggleVisibility([group], hasVisibleItems);
    });
  }

  resetVisibility() {
    this.toggleVisibility(this.itemTargets, true);
    this.toggleVisibility(this.groupTargets, true);
    this.toggleVisibility(this.emptyTargets, false);
  }

  // Upstream builds a Fuse index here; this keeps the same search() shape with
  // a plain case-insensitive substring match, so no npm dependency is needed.
  buildSearchIndex() {
    const items = this.itemTargets.map((el) => ({
      value: (el.dataset.value || "").toLowerCase(),
      element: el,
    }));
    return {
      search(query) {
        const q = query.toLowerCase();
        return items.filter((item) => item.value.includes(q)).map((item) => ({ item }));
      },
    };
  }

  handleKeydown(e) {
    const visibleItems = this.itemTargets.filter(
      (item) => !item.classList.contains("pk-hidden"),
    );
    if (e.key === "ArrowDown") {
      e.preventDefault();
      this.updateSelectedItem(visibleItems, 1);
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      this.updateSelectedItem(visibleItems, -1);
    } else if (e.key === "Enter" && this.selectedIndex !== -1) {
      e.preventDefault();
      visibleItems[this.selectedIndex].click();
    }
  }

  updateSelectedItem(visibleItems, direction) {
    if (this.selectedIndex >= 0) {
      this.toggleAriaSelected(visibleItems[this.selectedIndex], false);
    }

    this.selectedIndex += direction;

    // Ensure the selected index is within the bounds of the visible items
    if (this.selectedIndex < 0) {
      this.selectedIndex = visibleItems.length - 1;
    } else if (this.selectedIndex >= visibleItems.length) {
      this.selectedIndex = 0;
    }

    this.toggleAriaSelected(visibleItems[this.selectedIndex], true);
  }

  toggleAriaSelected(element, isSelected) {
    element.setAttribute("aria-selected", isSelected.toString());
  }

  deselectAll() {
    this.itemTargets.forEach((item) => this.toggleAriaSelected(item, false));
    this.selectedIndex = -1;
  }
}
