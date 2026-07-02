import { Controller } from "@hotwired/stimulus";

// Ported verbatim from ruby_ui's phlex-kit--select-item controller. Flips its own
// element's aria-selected when an item is chosen (the select controller invokes
// this on every item via the outlet), which drives the checkmark in select.css.
export default class extends Controller {
  handleSelectItem({ target }) {
    if (this.element.dataset.value == target.dataset.value) {
      this.element.setAttribute("aria-selected", true);
    } else {
      this.element.removeAttribute("aria-selected");
    }
  }
}
