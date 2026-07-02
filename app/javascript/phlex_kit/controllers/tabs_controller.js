import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--tabs"
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { active: String }

  connect() {
    if (!this.hasActiveValue && this.triggerTargets.length > 0) {
      this.activeValue = this.triggerTargets[0].dataset.value
    }
  }

  show(e) { this.activeValue = e.currentTarget.dataset.value }

  activeValueChanged(current, previous) {
    if (current === "" || current === previous) return
    this.contentTargets.forEach((el) => el.classList.add("pk-hidden"))
    this.triggerTargets.forEach((el) => { el.dataset.state = "inactive" })
    const c = this.activeContentTarget()
    if (c) c.classList.remove("pk-hidden")
    const t = this.activeTriggerTarget()
    if (t) t.dataset.state = "active"
  }

  activeTriggerTarget() { return this.triggerTargets.find((el) => el.dataset.value === this.activeValue) }
  activeContentTarget() { return this.contentTargets.find((el) => el.dataset.value === this.activeValue) }
}
