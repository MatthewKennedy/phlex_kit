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
    // Turbo snapshots at turbo:before-cache, BEFORE disconnect — close now or
    // the cached page restores a non-modal <dialog open> with scroll locked.
    document.addEventListener("turbo:before-cache", this.beforeCache)
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
    document.removeEventListener("turbo:before-cache", this.beforeCache)
    if (this.dialogTarget.open) this.handleClose()
  }
  beforeCache = () => {
    if (!this.dialogTarget.open) return
    this.dialogTarget.close()
    this.handleClose() // the close event is a queued task — too late for the snapshot
  }
  open(e) {
    e?.preventDefault()
    this.dialogTarget.showModal()
    // Save/restore rather than removeProperty: a host page (or another
    // component) may have set body overflow itself.
    this.previousOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"
  }
  dismiss() { this.dialogTarget.close() }
  // Only a click on the ::backdrop dismisses. e.target is the <dialog> for
  // backdrop clicks, but ALSO for clicks on the dialog's own padding/flex
  // gaps — disambiguate by testing the click point against the dialog's box.
  backdropClick(e) {
    if (e.target !== this.dialogTarget) return
    if (e.detail === 0) return // synthetic/keyboard click — no coordinates
    const r = this.dialogTarget.getBoundingClientRect()
    const inside = e.clientX >= r.left && e.clientX <= r.right && e.clientY >= r.top && e.clientY <= r.bottom
    if (!inside) this.dismiss()
  }
  handleClose = () => { document.body.style.overflow = this.previousOverflow ?? "" }
}
