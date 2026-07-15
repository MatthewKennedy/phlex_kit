import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--collapsible"
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { open: { type: Boolean, default: false } }

  connect() {
    // aria-expanded must live on the element AT reads state from — the
    // focused control, not the plain wrapper div. The trigger wrapper renders
    // aria-expanded server-side (it can't reach into its block), so resolve
    // the nested focusable control here, relocate the state onto it, and keep
    // toggling there. Wrapper-only triggers keep the wrapper as carrier.
    if (this.hasTriggerTarget) {
      this.control = this.triggerTarget.querySelector("button, [role='button'], a[href], input") || this.triggerTarget
      if (this.control !== this.triggerTarget) this.triggerTarget.removeAttribute("aria-expanded")
      // The trigger can't know the content's id at render time — wire
      // aria-controls here.
      if (this.hasContentTarget && this.contentTarget.id) {
        this.control.setAttribute("aria-controls", this.contentTarget.id)
      }
    }
    this.openValue ? this.open() : this.close()
  }
  toggle() { this.openValue = !this.openValue }
  openValueChanged(isOpen) { isOpen ? this.open() : this.close() }

  open() {
    if (this.hasContentTarget) { this.contentTarget.classList.remove("pk-hidden"); this.openValue = true }
    if (this.control) this.control.setAttribute("aria-expanded", "true")
    this.element.dataset.state = "open";
  }

  close() {
    if (this.hasContentTarget) { this.contentTarget.classList.add("pk-hidden"); this.openValue = false }
    if (this.control) this.control.setAttribute("aria-expanded", "false")
    this.element.dataset.state = "closed";
  }
}
