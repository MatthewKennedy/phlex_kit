import { Controller } from "@hotwired/stimulus";

// Fuzzy subsequence score: every query character must appear in order in the
// value (else null = no match). Consecutive runs compound, word-starts score
// extra, and a verbatim substring outranks scattered hits — so "set" beats
// "*s*al*e*s repor*t*" with "settings" on top. Dependency-free stand-in for
// what fuse.js gave ruby_ui.
function fuzzyScore(query, value) {
  if (!query) return 0;
  let qi = 0;
  let score = 0;
  let streak = 0;
  for (let vi = 0; vi < value.length && qi < query.length; vi++) {
    if (value[vi] === query[qi]) {
      streak++;
      score += streak;
      if (vi === 0 || /[\s\-_./]/.test(value[vi - 1])) score += 2;
      qi++;
    } else {
      streak = 0;
    }
  }
  if (qi < query.length) return null;
  if (value.includes(query)) score += query.length * 2;
  return score;
}

// Ported from ruby_ui's command controller. TWO changes from upstream: the
// fuse.js dependency is replaced with the dependency-free fuzzy matcher above
// (same search() shape, results sorted best-first), and show/hide + body
// scroll-lock use .pk-hidden / inline overflow (matching the shipped dialog)
// instead of Tailwind utility classes. Everything else (filtering, keyboard
// nav, dismiss) is unchanged.
// Connects to data-controller="phlex-kit--command"
export default class extends Controller {
  static targets = ["input", "group", "item", "empty", "separator", "list", "liveRegion"];

  connect() {
    this.selectedIndex = -1;
    // Remember what had focus before the palette grabbed it (for a cloned
    // dialog this is the element focused when the overlay was inserted), so
    // dismiss() can hand focus back instead of dropping it on <body>.
    this.previouslyFocused = document.activeElement;

    if (!this.hasInputTarget) {
      return;
    }

    this.generateItemIds();
    this.inputTarget.focus();
    this.searchIndex = this.buildSearchIndex();
    this.toggleVisibility(this.emptyTargets, false);
  }

  // ARIA plumbing: every result gets an id derived from the listbox id so the
  // input can point aria-activedescendant at the keyboard highlight, and
  // aria-controls is wired to the listbox (mirrors select_controller.js).
  generateItemIds() {
    const list = this.hasListTarget ? this.listTarget : this.element;
    if (!list.id) list.id = `pk-command-list-${Math.random().toString(36).slice(2, 10)}`;

    this.itemTargets.forEach((item, index) => {
      if (!item.id) item.id = `${list.id}-${index}`;
    });

    this.inputTarget.setAttribute("aria-controls", list.id);
  }

  dismiss() {
    // allow scroll on body
    document.body.style.removeProperty("overflow");
    const previous = this.previouslyFocused;
    // remove the element
    this.element.remove();
    // restore focus to wherever it was before the palette opened
    if (previous instanceof HTMLElement && document.contains(previous)) {
      previous.focus();
    }
  }

  // Focus trap for the cloned dialog overlay: Tab / Shift+Tab cycle among the
  // overlay's own focusable elements instead of escaping to the page beneath.
  trapFocus(e) {
    if (e.key !== "Tab") return;

    const focusables = Array.from(
      this.element.querySelectorAll(
        'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])',
      ),
    ).filter((el) => !el.closest(".pk-hidden"));

    if (focusables.length === 0) {
      e.preventDefault();
      return;
    }

    const first = focusables[0];
    const last = focusables[focusables.length - 1];
    const active = document.activeElement;

    if (e.shiftKey && active === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && active === last) {
      e.preventDefault();
      first.focus();
    } else if (!this.element.contains(active)) {
      e.preventDefault();
      first.focus();
    }
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
      this.announceResultCount(null);
      return;
    }

    this.toggleVisibility(this.itemTargets, false);

    const results = this.searchIndex.search(query);
    results.forEach((result) =>
      this.toggleVisibility([result.item.element], true),
    );

    this.announceResultCount(results.length);
    this.toggleVisibility(this.emptyTargets, results.length === 0);
    this.toggleVisibility(this.separatorTargets, false);
    this.updateGroupVisibility();
  }

  // Announce the filtered result count to screen readers (null = no query).
  announceResultCount(count) {
    if (!this.hasLiveRegionTarget) return;

    if (count === null) {
      this.liveRegionTarget.textContent = "";
    } else {
      this.liveRegionTarget.textContent =
        count === 0 ? "No results" : `${count} result${count === 1 ? "" : "s"}`;
    }
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
    this.toggleVisibility(this.separatorTargets, true);
    this.toggleVisibility(this.emptyTargets, false);
  }

  // Upstream builds a Fuse index here; this keeps the same search() shape —
  // [{ item }] sorted best-match-first — using the fuzzy scorer above.
  buildSearchIndex() {
    const items = this.itemTargets.map((el) => ({
      value: (el.dataset.value || "").toLowerCase(),
      element: el,
    }));
    return {
      search(query) {
        const q = query.toLowerCase();
        return items
          .map((item) => ({ item, score: fuzzyScore(q, item.value) }))
          .filter((result) => result.score !== null)
          .sort((a, b) => b.score - a.score);
      },
    };
  }

  handleKeydown(e) {
    // Disabled items stay visible (dimmed via [data-disabled]) but are
    // skipped by keyboard selection.
    const visibleItems = this.itemTargets.filter(
      (item) =>
        !item.classList.contains("pk-hidden") && !item.dataset.disabled,
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
    if (visibleItems.length === 0) return;

    if (this.selectedIndex >= 0 && visibleItems[this.selectedIndex]) {
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

    // Focus stays in the input; the highlighted option is exposed via
    // aria-activedescendant (result ids come from generateItemIds).
    if (this.hasInputTarget) {
      this.inputTarget.setAttribute(
        "aria-activedescendant",
        visibleItems[this.selectedIndex].id,
      );
    }
  }

  toggleAriaSelected(element, isSelected) {
    element.setAttribute("aria-selected", isSelected.toString());
  }

  deselectAll() {
    this.itemTargets.forEach((item) => this.toggleAriaSelected(item, false));
    this.selectedIndex = -1;

    // aria-activedescendant holds an element id; with nothing highlighted it
    // must be removed, not left pointing at a stale option.
    if (this.hasInputTarget) {
      this.inputTarget.removeAttribute("aria-activedescendant");
    }
  }
}
