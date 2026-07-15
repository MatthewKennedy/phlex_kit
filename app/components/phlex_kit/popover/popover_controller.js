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
      // Button-less fallback: keyboard toggling and popup semantics don't
      // come for free like they do with popoverTargetElement — wire Enter
      // (and Space, off text-entry controls) plus aria-haspopup/-expanded
      // onto the focusable child so AT users can discover and open it.
      this.fallbackInvoker = this.triggerTarget.querySelector("input, a[href], select, textarea, [tabindex]") || this.triggerTarget
      this.fallbackInvoker.setAttribute("aria-haspopup", "dialog")
      this.fallbackInvoker.setAttribute("aria-expanded", this.contentTarget.matches(":popover-open") ? "true" : "false")
      this.triggerTarget.addEventListener("pointerdown", this.armToggle)
      this.triggerTarget.addEventListener("click", this.toggle)
      this.triggerTarget.addEventListener("keydown", this.keyToggle)
    }
  }

  disconnect() {
    this.triggerTarget.removeEventListener("pointerdown", this.armToggle)
    this.triggerTarget.removeEventListener("click", this.toggle)
    this.triggerTarget.removeEventListener("keydown", this.keyToggle)
  }

  armToggle = () => { this.wasOpen = this.contentTarget.matches(":popover-open") }
  toggle = () => {
    if (this.wasOpen) { this.wasOpen = false; return }
    this.contentTarget.togglePopover()
  }
  keyToggle = (e) => {
    const textEntry = /^(INPUT|TEXTAREA|SELECT)$/.test(e.target.tagName)
    if (e.key !== "Enter" && !(e.key === " " && !textEntry)) return
    e.preventDefault()
    this.contentTarget.togglePopover()
  }

  // One stable handler added/removed symmetrically — an anonymous listener
  // here would pile up a duplicate on every target reconnect.
  syncState = (e) => {
    e.target.dataset.state = e.newState === "open" ? "open" : "closed"
    this.fallbackInvoker?.setAttribute("aria-expanded", e.newState === "open" ? "true" : "false")
  }

  contentTargetConnected(el) {
    // A Turbo snapshot serializes data-state="open" but :popover-open does
    // not survive the restore — resync before listening so host CSS keyed
    // on the state hook doesn't misfire.
    el.dataset.state = el.matches(":popover-open") ? "open" : "closed"
    el.addEventListener("toggle", this.syncState)
  }

  contentTargetDisconnected(el) {
    el.removeEventListener("toggle", this.syncState)
  }
}
