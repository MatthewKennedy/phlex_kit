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

  initialize() {
    // Stimulus fires [target]Connected before connect(): anything
    // itemTargetConnected uses must be initialized here (mirrors
    // combobox_controller.js).
    this.itemIdCounter = 0;
    this.searchEntries = [];
    this.selectedIndex = -1;
  }

  connect() {
    // Remember what had focus before the palette grabbed it (for a cloned
    // dialog this is the element focused when the overlay was inserted), so
    // dismiss() can hand focus back instead of dropping it on <body>.
    this.previouslyFocused = document.activeElement;

    if (!this.hasInputTarget) {
      return;
    }

    this.generateItemIds();
    // Only the cloned dialog overlay grabs focus on connect — an inline
    // palette connecting at page load must not steal it.
    if (this.isDialogClone()) this.inputTarget.focus();
    this.toggleVisibility(this.emptyTargets, false);
  }

  // The command-dialog controller clones its <template> content into <body>;
  // the clone's wrapper carries this marker (CommandDialogContent renders it).
  isDialogClone() {
    return this.element.hasAttribute("data-phlex-kit--command-dialog-instance");
  }

  // ARIA plumbing: aria-controls is wired to the listbox (mirrors
  // select_controller.js); the per-result ids come from itemTargetConnected.
  generateItemIds() {
    this.inputTarget.setAttribute("aria-controls", this.listId());
  }

  listId() {
    const list = this.hasListTarget ? this.listTarget : this.element;
    if (!list.id) list.id = `pk-command-list-${Math.random().toString(36).slice(2, 10)}`;
    return list.id;
  }

  // Every result gets an id derived from the listbox id so the input can
  // point aria-activedescendant at the keyboard highlight, and a search-index
  // entry so filtering can find it. A target callback (not a connect() loop)
  // so items rendered in by the host after load are id'd and findable too.
  // Counter-based, so a removed item's id is never reissued to a later
  // arrival (mirrors combobox_controller.js).
  itemTargetConnected(item) {
    if (!item.id) item.id = `${this.listId()}-${this.itemIdCounter++}`;
    this.searchEntries.push({
      value: (item.dataset.value || "").toLowerCase(),
      text: (item.dataset.text || "").toLowerCase(),
      element: item,
    });
  }

  itemTargetDisconnected(item) {
    this.searchEntries = this.searchEntries.filter(
      (entry) => entry.element !== item,
    );
  }

  dismiss() {
    // Cloned dialog overlay: tear the clone down and hand focus back.
    if (this.isDialogClone()) {
      // Dispatched BEFORE teardown: the command-dialog controller listens on
      // the overlay and un-inerts the page here — focus() below would be a
      // silent no-op while previouslyFocused sits under an inert ancestor.
      this.dispatch("dismiss");
      // allow scroll on body
      document.body.style.removeProperty("overflow");
      const previous = this.previouslyFocused;
      // remove the element
      this.element.remove();
      // restore focus to wherever it was before the palette opened
      if (previous instanceof HTMLElement && document.contains(previous)) {
        previous.focus();
      }
      return;
    }

    // Inline palette: removing the element would delete it permanently.
    // Reset the query instead and let the host react via the dispatched
    // phlex-kit--command:dismiss event.
    if (this.hasInputTarget && this.inputTarget.value !== "") {
      this.inputTarget.value = "";
      this.deselectAll();
      this.resetVisibility();
      this.announceResultCount(null);
    }
    this.dispatch("dismiss");
  }

  // Guards the items' default href="#": without it an Enter-synthesized
  // click() or a mouse click scrolls to top and appends # to the URL
  // (mirrors dropdown_menu_controller's close() guard).
  onItemClick(event) {
    if (event?.target?.closest?.('a[href="#"]')) event.preventDefault();
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

    const results = this.searchItems(query);
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

  // Upstream builds a Fuse index here; this keeps the same result shape —
  // [{ item }] sorted best-match-first — using the fuzzy scorer above over
  // the live searchEntries (maintained by itemTargetConnected/Disconnected,
  // so host-rendered items are searchable). Both data-value and data-text are
  // searchable (an item's `text:` was rendered but never indexed); the better
  // of the two scores wins.
  searchItems(query) {
    const q = query.toLowerCase();
    return this.searchEntries
      .map((item) => {
        const scores = [item.value, item.text]
          .filter(Boolean)
          .map((field) => fuzzyScore(q, field))
          .filter((score) => score !== null);
        return { item, score: scores.length ? Math.max(...scores) : null };
      })
      .filter((result) => result.score !== null)
      .sort((a, b) => b.score - a.score);
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
    // Keep the highlight visible inside the max-height scrollable list.
    visibleItems[this.selectedIndex].scrollIntoView({ block: "nearest" });

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
