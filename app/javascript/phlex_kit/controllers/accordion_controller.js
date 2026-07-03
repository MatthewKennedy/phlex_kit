import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--accordion"
// Ported from ruby_ui's ruby-ui--accordion controller, reworked to use the native
// Web Animations API instead of the `motion` package (no extra JS dependency).
export default class extends Controller {
  static targets = ["icon", "content"]
  static values = {
    open: { type: Boolean, default: false },
    animationDuration: { type: Number, default: 150 },
    rotateIcon: { type: Number, default: 180 },
  }

  connect() {
    const d = this.animationDurationValue
    this.animationDurationValue = 0
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
      const ctrl = this.application.getControllerForElementAndIdentifier(el, "phlex-kit--accordion")
      if (ctrl && ctrl.openValue) ctrl.openValue = false
    })
  }
  openValueChanged(isOpen) { isOpen ? this.open() : this.close() }

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

  reveal() {
    const c = this.contentTarget
    c.removeAttribute("hidden")
    c.dataset.state = "open"
    const h = c.scrollHeight
    c.animate([{ height: c.style.height || "0px" }, { height: `${h}px` }],
      { duration: this.animationDurationValue, easing: "ease-in-out" })
    c.style.height = `${h}px`
  }

  hide() {
    const c = this.contentTarget
    c.dataset.state = "closed"
    const from = c.scrollHeight
    const a = c.animate([{ height: `${from}px` }, { height: "0px" }],
      { duration: this.animationDurationValue, easing: "ease-in-out" })
    c.style.height = "0px"
    a.finished.then(() => { if (c.dataset.state === "closed") c.setAttribute("hidden", "") }).catch(() => {})
  }

  rotate() {
    this.iconTarget.style.transform = `rotate(${this.openValue ? this.rotateIconValue : 0}deg)`
  }
}
