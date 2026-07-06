import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--dialog". Ported from ruby_ui.
// connect() auto-wires the dialog's accessible name: when the caller didn't
// pass labelledby:/describedby: to DialogContent, the title/description parts
// get generated ids and the <dialog> points at them.
export default class extends Controller {
  static targets = ["dialog"]
  static values = { open: { type: Boolean, default: false } }

  connect() {
    this.dialogTarget.addEventListener("close", this.handleClose)
    this.#wireAria("aria-labelledby", ".pk-dialog-title")
    this.#wireAria("aria-describedby", ".pk-dialog-description")
    if (this.openValue) this.open()
  }

  #wireAria(attr, selector) {
    if (this.dialogTarget.getAttribute(attr)) return
    const el = this.dialogTarget.querySelector(selector)
    if (!el) return
    if (!el.id) el.id = `pk-dialog-${attr.slice(5)}-${Math.random().toString(36).slice(2, 10)}`
    this.dialogTarget.setAttribute(attr, el.id)
  }
  disconnect() {
    this.dialogTarget.removeEventListener("close", this.handleClose)
    document.body.style.removeProperty("overflow")
  }
  open(e) { e?.preventDefault(); this.dialogTarget.showModal(); document.body.style.overflow = "hidden" }
  dismiss() { this.dialogTarget.close() }
  backdropClick(e) { if (e.target === this.dialogTarget) this.dismiss() }
  handleClose = () => { document.body.style.removeProperty("overflow") }
}
