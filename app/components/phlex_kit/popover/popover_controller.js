import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--popover". Click to toggle; click
// outside to close. CSS positions the panel under the trigger.
export default class extends Controller {
  static targets = ["trigger", "content"]
  connect() { this.onDoc = (e) => { if (!this.element.contains(e.target)) this.hide() } }
  disconnect() { document.removeEventListener("click", this.onDoc) }
  toggle(e) { e?.preventDefault(); this.contentTarget.classList.contains("pk-hidden") ? this.show() : this.hide() }
  show() { this.contentTarget.classList.remove("pk-hidden"); this.contentTarget.dataset.state = "open"; document.addEventListener("click", this.onDoc) }
  hide() { this.contentTarget.classList.add("pk-hidden"); this.contentTarget.dataset.state = "closed"; document.removeEventListener("click", this.onDoc) }
}
