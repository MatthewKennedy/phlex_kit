import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--popover". The panel is a native
// [popover=auto] — the browser owns light dismiss + Escape; CSS anchor
// positioning places it (popover.css). Toggling is native too: connect()
// points the trigger's button at the panel via popoverTargetElement, so the
// browser handles mouse + keyboard activation and exposes the expanded
// state to assistive tech — no imperative toggle, no invoker/light-dismiss
// race. Button-less triggers (the date picker's input) fall back to a
// click toggle; wasOpen records the open state at pointerdown because
// light dismiss fires first and the click would otherwise reopen.
export default class extends Controller {
  static targets = ["trigger", "content"]

  connect() {
    const invoker = this.triggerTarget.querySelector("button")
    if (invoker) {
      invoker.popoverTargetElement = this.contentTarget
    } else {
      this.triggerTarget.addEventListener("pointerdown", this.armToggle)
      this.triggerTarget.addEventListener("click", this.toggle)
    }
  }

  disconnect() {
    this.triggerTarget.removeEventListener("pointerdown", this.armToggle)
    this.triggerTarget.removeEventListener("click", this.toggle)
  }

  armToggle = () => { this.wasOpen = this.contentTarget.matches(":popover-open") }
  toggle = () => {
    if (this.wasOpen) { this.wasOpen = false; return }
    this.contentTarget.togglePopover()
  }

  // One stable handler added/removed symmetrically — an anonymous listener
  // here would pile up a duplicate on every target reconnect.
  syncState = (e) => { e.target.dataset.state = e.newState === "open" ? "open" : "closed" }

  contentTargetConnected(el) {
    el.addEventListener("toggle", this.syncState)
  }

  contentTargetDisconnected(el) {
    el.removeEventListener("toggle", this.syncState)
  }
}
