import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--dialog". Ported from ruby_ui.
export default class extends Controller {
  static targets = ["dialog"]
  static values = { open: { type: Boolean, default: false } }

  connect() {
    this.dialogTarget.addEventListener("close", this.handleClose)
    if (this.openValue) this.open()
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
