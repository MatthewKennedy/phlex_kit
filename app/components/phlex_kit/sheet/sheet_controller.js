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
    if (this.openValue) this.open()
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.clearOverlay)
    this.clearOverlay()
  }

  open() {
    if (this.overlay?.isConnected) return
    document.body.insertAdjacentHTML("beforeend", this.contentTarget.innerHTML)
    this.overlay = document.body.lastElementChild
  }
}
