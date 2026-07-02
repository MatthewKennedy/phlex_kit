import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--collapsible"
export default class extends Controller {
  static targets = ["content"]
  static values = { open: { type: Boolean, default: false } }

  connect() { this.openValue ? this.open() : this.close() }
  toggle() { this.openValue = !this.openValue }
  openValueChanged(isOpen) { isOpen ? this.open() : this.close() }

  open() { if (this.hasContentTarget) { this.contentTarget.classList.remove("pk-hidden"); this.openValue = true } }
  close() { if (this.hasContentTarget) { this.contentTarget.classList.add("pk-hidden"); this.openValue = false } }
}
