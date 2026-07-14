import { Controller } from "@hotwired/stimulus"

// Ported from ruby_ui's calendar-input controller (Stimulus-only upstream).
// The calendar's outlet pushes the picked, formatted date into this element.
// Connects to data-controller="phlex-kit--calendar-input"
export default class extends Controller {
  setValue(value) {
    if (this.element.value === value) return
    this.element.value = value
    // Programmatic .value assignment fires nothing — dispatch input/change so
    // form frameworks, validators and Stimulus actions bound to the field see
    // the calendar's write.
    this.element.dispatchEvent(new Event("input", { bubbles: true }))
    this.element.dispatchEvent(new Event("change", { bubbles: true }))
  }
}
