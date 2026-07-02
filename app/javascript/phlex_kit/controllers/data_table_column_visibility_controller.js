import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's data-table-column-visibility controller (Stimulus-only
// upstream), identifiers renamed ruby-ui → phlex-kit and the Tailwind hidden
// class swapped for .pk-hidden. Toggles every cell carrying a matching
// data-column attribute inside the enclosing data table.
// Connects to data-controller="phlex-kit--data-table-column-visibility"
export default class extends Controller {
  toggle(event) {
    const key = event.target.dataset.columnKey;
    const visible = event.target.checked;
    const root = this.element.closest('[data-controller~="phlex-kit--data-table"]');
    if (!root) return;
    root
      .querySelectorAll(`[data-column="${key}"]`)
      .forEach((el) => el.classList.toggle("pk-hidden", !visible));
  }
}
