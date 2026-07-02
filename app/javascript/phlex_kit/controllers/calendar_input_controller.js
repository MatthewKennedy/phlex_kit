import { Controller } from "@hotwired/stimulus"

// Ported from ruby_ui's calendar-input controller (Stimulus-only upstream).
// The calendar's outlet pushes the picked, formatted date into this element.
// Connects to data-controller="phlex-kit--calendar-input"
export default class extends Controller {
  setValue(value) {
    this.element.value = value
  }
}
