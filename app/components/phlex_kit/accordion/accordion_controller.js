import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--accordion"
// Ported from ruby_ui's ruby-ui--accordion controller, reworked to use the native
// Web Animations API instead of the `motion` package (no extra JS dependency).
let uid = 0

export default class extends Controller {
  static targets = ["icon", "content", "trigger"]
  static values = {
    open: { type: Boolean, default: false },
    animationDuration: { type: Number, default: 150 },
    rotateIcon: { type: Number, default: 180 },
  }

  connect() {
    this.wireAria()
    // Apply the initial state without animating (the initial valueChanged
    // callback is skipped — it fires before connect()).
    const d = this.animationDurationValue
    this.animationDurationValue = 0
    if (this.hasTriggerTarget) this.triggerTarget.setAttribute("aria-expanded", this.openValue ? "true" : "false")
    this.openValue ? this.open() : this.close()
    this.animationDurationValue = d
  }

  toggle() {
    const next = !this.openValue
    if (next) this.closeSiblings()
    this.openValue = next
  }

  // In a type="single" accordion (shadcn's default), opening one item closes
  // the rest.
  closeSiblings() {
    const root = this.element.closest(".pk-accordion")
    if (!root || root.dataset.type !== "single") return
    root.querySelectorAll('[data-controller~="phlex-kit--accordion"]').forEach((el) => {
      if (el === this.element) return
      // Skip items of a NESTED accordion — querySelectorAll descends into
      // item content, and opening an outer item collapsed inner ones too.
      if (el.closest(".pk-accordion") !== root) return
      const ctrl = this.application.getControllerForElementAndIdentifier(el, "phlex-kit--accordion")
      if (ctrl && ctrl.openValue) ctrl.openValue = false
    })
  }
  openValueChanged(isOpen, wasOpen) {
    // Stimulus fires the initial value callback BEFORE connect() — before
    // connect zeroes the duration — so a server-rendered open item visibly
    // animated open on every page load. connect() applies the initial state.
    if (wasOpen === undefined) return
    if (this.hasTriggerTarget) this.triggerTarget.setAttribute("aria-expanded", isOpen ? "true" : "false")
    isOpen ? this.open() : this.close()
  }

  // Pair the trigger with its content: assign per-instance ids (render time
  // has no shared item value, so the parts can't derive them), wire
  // aria-controls/aria-labelledby, and propagate a disabled item onto the
  // actual button so it drops out of the tab order.
  wireAria() {
    if (!this.hasTriggerTarget) return
    const id = ++uid
    const trigger = this.triggerTarget
    if (!trigger.id) trigger.id = `pk-accordion-trigger-${id}`
    if (this.hasContentTarget) {
      const content = this.contentTarget
      if (!content.id) content.id = `pk-accordion-panel-${id}`
      trigger.setAttribute("aria-controls", content.id)
      content.setAttribute("aria-labelledby", trigger.id)
    }
    if ("disabled" in this.element.dataset) trigger.disabled = true
  }

  open() {
    if (!this.hasContentTarget) return
    this.reveal()
    if (this.hasIconTarget) this.rotate()
  }

  close() {
    if (!this.hasContentTarget) return
    this.hide()
    if (this.hasIconTarget) this.rotate()
  }

  // Honor prefers-reduced-motion: collapse the grow/shrink to a jump-cut
  // (duration 0 keeps the finished-promise bookkeeping intact).
  get effectiveDuration() {
    return matchMedia("(prefers-reduced-motion: reduce)").matches ? 0 : this.animationDurationValue
  }

  reveal() {
    const c = this.contentTarget
    c.removeAttribute("hidden")
    c.dataset.state = "open"
    const h = c.scrollHeight
    const a = c.animate([{ height: c.style.height || "0px" }, { height: `${h}px` }],
      { duration: this.effectiveDuration, easing: "ease-in-out" })
    c.style.height = `${h}px`
    // Settle at auto, not the frozen pixel height — with overflow hidden a
    // later content growth (or a resize that rewraps text) silently clipped.
    a.finished.then(() => { if (c.dataset.state === "open") c.style.height = "auto" }).catch(() => {})
  }

  hide() {
    const c = this.contentTarget
    c.dataset.state = "closed"
    const from = c.scrollHeight
    const a = c.animate([{ height: `${from}px` }, { height: "0px" }],
      { duration: this.effectiveDuration, easing: "ease-in-out" })
    c.style.height = "0px"
    a.finished.then(() => { if (c.dataset.state === "closed") c.setAttribute("hidden", "") }).catch(() => {})
  }

  rotate() {
    this.iconTarget.style.transform = `rotate(${this.openValue ? this.rotateIconValue : 0}deg)`
  }
}
