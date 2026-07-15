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
    // open: is one-shot — the reflected value sits in the Turbo snapshot, so
    // a cache-restored reconnect would re-open a dismissed dialog.
    this.openValue = false
    this.dialogTarget.showModal()
    // Save/restore rather than removeProperty: a host page (or another
    // component) may have set body overflow itself.
    this.previousOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"
  }
  dismiss() { this.dialogTarget.close() }
  // Only a press that STARTED on the backdrop may dismiss: a drag-select
  // beginning inside the panel and released over the backdrop fires the
  // click on <dialog> with outside coordinates — that must not close it
  // (Radix guards on pointerdown origin the same way).
  backdropPointerdown(e) {
    this.pressStartedOutside = e.target === this.dialogTarget && !this.#insideBox(e)
  }
  // Only a click on the ::backdrop dismisses. e.target is the <dialog> for
  // backdrop clicks, but ALSO for clicks on the dialog's own padding/flex
  // gaps — disambiguate by testing the click point against the dialog's box.
  backdropClick(e) {
    if (e.target !== this.dialogTarget) return
    if (e.detail === 0) return // synthetic/keyboard click — no coordinates
    if (!this.pressStartedOutside) return
    this.pressStartedOutside = false
    if (!this.#insideBox(e)) this.dismiss()
  }
  #insideBox(e) {
    const r = this.dialogTarget.getBoundingClientRect()
    return e.clientX >= r.left && e.clientX <= r.right && e.clientY >= r.top && e.clientY <= r.bottom
  }
  handleClose = () => { document.body.style.overflow = this.previousOverflow ?? "" }
}
