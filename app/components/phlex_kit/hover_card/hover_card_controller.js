import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--hover-card". Show on hover/focus
// with a small open/close delay. The panel is a native [popover=manual]
// (top layer; manual because the controller owns open/close — hover
// semantics want no light dismiss), anchor-positioned by hover_card.css.
// Manual popovers get no built-in Escape dismiss, so a window keydown
// listener (bound only while open, cf. tooltip_controller.js) closes the
// card immediately — the keyboard/touch escape hatch for a hover surface.
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { openDelay: { type: Number, default: 200 }, closeDelay: { type: Number, default: 200 } }

  connect() {
    // Turbo snapshots BEFORE disconnect, so a stale data-state="open" would
    // otherwise resurrect host CSS keyed on the state hook after a cache
    // restore — close now (popover_controller.js's contentTargetConnected /
    // context_menu_controller.js's turbo:before-cache pattern combined).
    this.onBeforeCache = () => {
      if (this.contentTarget.matches(":popover-open")) {
        clearTimeout(this.t)
        this.#close()
      }
    }
    document.addEventListener("turbo:before-cache", this.onBeforeCache)
  }

  contentTargetConnected(el) {
    // A reconnect (Turbo cache restore, or the detach/reattach it's tested
    // with) can hand us markup whose data-state was serialized while open —
    // :popover-open does not survive the restore, so resync before anything
    // reads the hook.
    el.dataset.state = el.matches(":popover-open") ? "open" : "closed"
  }

  show() {
    clearTimeout(this.t)
    this.t = setTimeout(() => {
      if (!this.contentTarget.matches(":popover-open")) this.contentTarget.showPopover()
      this.contentTarget.dataset.state = "open"
      this.#bindEscape()
    }, this.openDelayValue)
  }
  hide() {
    clearTimeout(this.t)
    this.t = setTimeout(() => this.#close(), this.closeDelayValue)
  }
  disconnect() {
    clearTimeout(this.t)
    this.#unbindEscape()
    document.removeEventListener("turbo:before-cache", this.onBeforeCache)
  }

  #close() {
    if (this.contentTarget.matches(":popover-open")) this.contentTarget.hidePopover()
    this.contentTarget.dataset.state = "closed"
    this.#unbindEscape()
  }
  #bindEscape() {
    if (this.onKeydown) return
    this.onKeydown = (e) => {
      if (e.key !== "Escape") return
      clearTimeout(this.t)
      this.#close()
    }
    window.addEventListener("keydown", this.onKeydown)
  }
  #unbindEscape() {
    if (!this.onKeydown) return
    window.removeEventListener("keydown", this.onKeydown)
    this.onKeydown = null
  }
}
