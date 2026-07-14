import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--collapsible"
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { open: { type: Boolean, default: false } }

  connect() {
    // The trigger renders aria-expanded from its own `open:` kwarg but can't
    // know the content's id at render time — wire aria-controls here.
    if (this.hasTriggerTarget && this.hasContentTarget && this.contentTarget.id) {
      this.triggerTarget.setAttribute("aria-controls", this.contentTarget.id)
    }
    this.openValue ? this.open() : this.close()
  }
  toggle() { this.openValue = !this.openValue }
  openValueChanged(isOpen) { isOpen ? this.open() : this.close() }

  open() {
    if (this.hasContentTarget) { this.contentTarget.classList.remove("pk-hidden"); this.openValue = true }
    if (this.hasTriggerTarget) this.triggerTarget.setAttribute("aria-expanded", "true")
    this.element.dataset.state = "open";
  }

  close() {
    if (this.hasContentTarget) { this.contentTarget.classList.add("pk-hidden"); this.openValue = false }
    if (this.hasTriggerTarget) this.triggerTarget.setAttribute("aria-expanded", "false")
    this.element.dataset.state = "closed";
  }
}
