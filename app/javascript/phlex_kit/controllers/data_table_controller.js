import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's data-table controller (Stimulus-only upstream),
// identifiers renamed ruby-ui → phlex-kit and the Tailwind hidden class swapped
// for the kit's .pk-hidden. Row selection, select-all indeterminate state,
// bulk-action visibility and row-detail expansion.
// Connects to data-controller="phlex-kit--data-table"
export default class extends Controller {
  static targets = [
    "selectAll",
    "rowCheckbox",
    "selectionSummary",
    "selectionBar",
    "bulkActions",
  ];

  connect() {
    this.updateState();
  }

  toggleAll(event) {
    const checked = event.target.checked;
    this.rowCheckboxTargets.forEach((cb) => {
      cb.checked = checked;
    });
    this.updateState();
  }

  toggleRow() {
    this.updateState();
  }

  toggleRowDetail(event) {
    const button = event.currentTarget;
    const id = button.getAttribute("aria-controls");
    if (!id) return;
    const target = document.getElementById(id);
    if (!target) return;
    const expanded = button.getAttribute("aria-expanded") === "true";
    button.setAttribute("aria-expanded", String(!expanded));
    target.classList.toggle("pk-hidden", expanded);
  }

  updateState() {
    const total = this.rowCheckboxTargets.length;
    const selected = this.rowCheckboxTargets.filter((cb) => cb.checked).length;

    if (this.hasSelectAllTarget) {
      this.selectAllTarget.checked = total > 0 && selected === total;
      this.selectAllTarget.indeterminate = selected > 0 && selected < total;
    }

    if (this.hasSelectionSummaryTarget) {
      this.selectionSummaryTarget.textContent = `${selected} of ${total} row(s) selected.`;
    }

    if (this.hasBulkActionsTarget) {
      this.bulkActionsTarget.classList.toggle("pk-hidden", selected === 0);
    }
  }
}
