import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--hover-card". Show on hover/focus
// with a small open/close delay. The panel is a native [popover=manual]
// (top layer; manual because the controller owns open/close — hover
// semantics want no light dismiss), anchor-positioned by hover_card.css.
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { openDelay: { type: Number, default: 200 }, closeDelay: { type: Number, default: 200 } }
  show() {
    clearTimeout(this.t)
    this.t = setTimeout(() => {
      if (!this.contentTarget.matches(":popover-open")) this.contentTarget.showPopover()
      this.contentTarget.dataset.state = "open"
    }, this.openDelayValue)
  }
  hide() {
    clearTimeout(this.t)
    this.t = setTimeout(() => {
      if (this.contentTarget.matches(":popover-open")) this.contentTarget.hidePopover()
      this.contentTarget.dataset.state = "closed"
    }, this.closeDelayValue)
  }
  disconnect() { clearTimeout(this.t) }
}
