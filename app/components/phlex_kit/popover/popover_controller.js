import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--popover". The panel is a native
// [popover=auto] — the browser owns light dismiss + Escape; CSS anchor
// positioning places it (popover.css). Light dismiss fires on pointerdown
// outside the panel, so a click on the trigger would close-then-reopen:
// armToggle records the open state at pointerdown and toggle skips the
// reopen.
export default class extends Controller {
  static targets = ["trigger", "content"]
  armToggle() { this.wasOpen = this.contentTarget.matches(":popover-open") }
  toggle(e) { e?.preventDefault(); if (this.wasOpen) return; this.contentTarget.showPopover() }
  contentTargetConnected(el) {
    el.addEventListener("toggle", (e) => { el.dataset.state = e.newState === "open" ? "open" : "closed" })
  }
}
