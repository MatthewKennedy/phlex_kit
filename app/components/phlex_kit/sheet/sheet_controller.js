import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--sheet". Clones the content <template>
// into <body> on open. Ported from ruby_ui. Guards against double-opening (one
// live clone at a time) and clears the clone on turbo:before-cache so a cached
// page never restores a stale overlay. The clone's own phlex-kit--sheet-content
// controller owns the modal behavior (focus trap, Escape, scroll lock).
export default class extends Controller {
  static targets = ["content"]
  static values = { open: { type: Boolean, default: false } }

  initialize() {
    this.overlay = null
    this.clearOverlay = () => {
      if (this.overlay?.isConnected) this.overlay.remove()
      this.overlay = null
    }
  }

  connect() {
    document.addEventListener("turbo:before-cache", this.clearOverlay)
    // Popup semantics for AT: the trigger's real control announces that it
    // opens a dialog, and expanded state tracks the clone's lifetime (the
    // content controller signals removal via phlex-kit:sheet-content:closed).
    this.invoker = this.element.querySelector(".pk-sheet-trigger button, .pk-sheet-trigger a, .pk-sheet-trigger [tabindex]")
    this.invoker?.setAttribute("aria-haspopup", "dialog")
    this.invoker?.setAttribute("aria-expanded", "false")
    this.onOverlayClosed = () => {
      if (!this.overlay?.isConnected) this.invoker?.setAttribute("aria-expanded", "false")
    }
    document.addEventListener("phlex-kit:sheet-content:closed", this.onOverlayClosed)
    if (this.openValue) this.open()
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.clearOverlay)
    document.removeEventListener("phlex-kit:sheet-content:closed", this.onOverlayClosed)
    this.clearOverlay()
  }

  open() {
    if (this.overlay?.isConnected) return
    // open: is one-shot — the reflected value sits in the Turbo snapshot, so
    // a cache-restored reconnect would re-open a dismissed sheet.
    this.openValue = false
    document.body.insertAdjacentHTML("beforeend", this.contentTarget.innerHTML)
    this.overlay = document.body.lastElementChild
    this.invoker?.setAttribute("aria-expanded", "true")
  }
}
