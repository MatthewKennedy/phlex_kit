import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--hover-card". Show on hover/focus with a
// small open/close delay. CSS positions the card under the trigger.
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { openDelay: { type: Number, default: 200 }, closeDelay: { type: Number, default: 200 } }
  show() { clearTimeout(this.t); this.t = setTimeout(() => { this.contentTarget.classList.remove("pk-hidden"); this.contentTarget.dataset.state = "open" }, this.openDelayValue) }
  hide() { clearTimeout(this.t); this.t = setTimeout(() => { this.contentTarget.classList.add("pk-hidden"); this.contentTarget.dataset.state = "closed" }, this.closeDelayValue) }
  disconnect() { clearTimeout(this.t) }
}
