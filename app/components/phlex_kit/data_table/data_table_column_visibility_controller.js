import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's data-table-column-visibility controller (Stimulus-only
// upstream), identifiers renamed ruby-ui → phlex-kit and the Tailwind hidden
// class swapped for .pk-hidden. Toggles every cell carrying a matching
// data-column attribute inside the enclosing data table.
// Connects to data-controller="phlex-kit--data-table-column-visibility"
export default class extends Controller {
  toggle(event) {
    // The change event originates on the checkbox, but data-column-key lives
    // on the menu row (DropdownMenuCheckboxItem) — look up through ancestors.
    const key = event.target.closest("[data-column-key]")?.dataset.columnKey;
    const visible = event.target.checked;
    if (!key) return;
    const root = this.element.closest('[data-controller~="phlex-kit--data-table"]');
    if (!root) return;
    root
      .querySelectorAll(`[data-column="${CSS.escape(key)}"]`)
      .forEach((el) => el.classList.toggle("pk-hidden", !visible));
  }
}
