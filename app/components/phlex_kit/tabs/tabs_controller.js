import { Controller } from "@hotwired/stimulus"

let uid = 0

// Connects to data-controller="phlex-kit--tabs"
export default class extends Controller {
  static targets = ["list", "trigger", "content"]
  static values = { active: String }

  connect() {
    this.scopeIds()
    if (this.hasListTarget && this.element.classList.contains("vertical")) {
      this.listTarget.setAttribute("aria-orientation", "vertical")
    }
    if (!this.hasActiveValue && this.triggerTargets.length > 0) {
      this.activeValue = this.triggerTargets[0].dataset.value
    } else {
      this.sync()
    }
  }

  show(e) { this.activeValue = e.currentTarget.dataset.value }

  // APG tabs keyboard model on the tablist: arrows move focus AND activate
  // (shadcn/Radix activation-on-focus), Home/End jump to the ends. Vertical
  // tab sets also answer to ArrowUp/ArrowDown.
  keydown(event) {
    const vertical = this.element.classList.contains("vertical")
    const nextKeys = vertical ? ["ArrowRight", "ArrowDown"] : ["ArrowRight"]
    const prevKeys = vertical ? ["ArrowLeft", "ArrowUp"] : ["ArrowLeft"]
    const triggers = this.triggerTargets.filter((el) => !el.disabled)
    if (triggers.length === 0) return
    const index = triggers.indexOf(document.activeElement)
    let target
    if (nextKeys.includes(event.key)) target = triggers[(index + 1) % triggers.length]
    // index is -1 when focus isn't on a trigger — treat prev as "last"
    // (the modulo would land on n-2 otherwise).
    else if (prevKeys.includes(event.key)) target = triggers[index === -1 ? triggers.length - 1 : (index - 1 + triggers.length) % triggers.length]
    else if (event.key === "Home") target = triggers[0]
    else if (event.key === "End") target = triggers[triggers.length - 1]
    if (!target) return
    event.preventDefault()
    target.focus()
    this.activeValue = target.dataset.value
  }

  activeValueChanged(current, previous) {
    if (current === "" || current === previous) return
    this.sync()
  }

  // Reflect the active value onto every trigger/panel: visibility,
  // data-state, aria-selected, and the roving tabindex.
  sync() {
    this.contentTargets.forEach((el) => el.classList.toggle("pk-hidden", el.dataset.value !== this.activeValue))
    this.triggerTargets.forEach((el) => {
      const active = el.dataset.value === this.activeValue
      el.dataset.state = active ? "active" : "inactive"
      el.setAttribute("aria-selected", active ? "true" : "false")
      el.setAttribute("tabindex", active ? "0" : "-1")
    })
  }

  // The parts render deterministic ids derived from their value, which would
  // collide across multiple tab sets on one page — re-scope them with a
  // per-instance prefix and rewire aria-controls/aria-labelledby. Caller-
  // supplied (non pk-tabs-*) ids are left alone.
  scopeIds() {
    const prefix = `pk-tabs-${++uid}`
    this.triggerTargets.forEach((trigger) => {
      const value = trigger.dataset.value
      const panel = this.contentTargets.find((el) => el.dataset.value === value)
      if (!trigger.id || trigger.id.startsWith("pk-tabs-trigger-")) trigger.id = `${prefix}-trigger-${value}`
      if (!panel) return
      if (!panel.id || panel.id.startsWith("pk-tabs-panel-")) panel.id = `${prefix}-panel-${value}`
      trigger.setAttribute("aria-controls", panel.id)
      panel.setAttribute("aria-labelledby", trigger.id)
    })
  }

  activeTriggerTarget() { return this.triggerTargets.find((el) => el.dataset.value === this.activeValue) }
  activeContentTarget() { return this.contentTargets.find((el) => el.dataset.value === this.activeValue) }
}
