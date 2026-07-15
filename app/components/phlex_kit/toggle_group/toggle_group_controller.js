import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--toggle-group"
export default class extends Controller {
  static targets = ["item", "input"]
  static values = { type: String, name: String }

  connect() { this.reconcile() }

  select(event) {
    const item = event.currentTarget
    if (item.disabled) return
    if (this.typeValue === "single") {
      this.itemTargets.forEach((el) => this.setPressed(el, el === item))
    } else {
      this.setPressed(item, !this.isPressed(item))
    }
    this.rebuildInputs()
    this.updateRovingTabindex(item)
    // Parity with Toggle: announce the selection as
    // "phlex-kit--toggle-group:change" — single carries the one selected
    // value (radiogroup semantics: no deselect), multiple the pressed array.
    const values = this.itemTargets.filter((el) => this.isPressed(el)).map((el) => el.dataset.value)
    this.dispatch("change", {
      detail: this.typeValue === "single" ? { value: values[0] ?? null } : { value: values },
      bubbles: true
    })
  }

  navigate(event) {
    if (this.typeValue !== "single") return
    const items = this.enabledItems()
    if (items.length === 0) return
    const currentIndex = items.indexOf(event.currentTarget)
    let nextIndex = currentIndex
    // In RTL the horizontal arrows mirror (physical LEFT = next); Up/Down are
    // unaffected. Runtime dir check is reliable after a dynamic flip.
    const rtl = getComputedStyle(this.element).direction === "rtl"
    const fwd = rtl ? "ArrowLeft" : "ArrowRight"
    const back = rtl ? "ArrowRight" : "ArrowLeft"
    if (event.key === fwd || event.key === "ArrowDown") nextIndex = (currentIndex + 1) % items.length
    else if (event.key === back || event.key === "ArrowUp") nextIndex = (currentIndex - 1 + items.length) % items.length
    else if (event.key === "Home") nextIndex = 0
    else if (event.key === "End") nextIndex = items.length - 1
    else if (event.key === " " || event.key === "Enter") { event.preventDefault(); event.currentTarget.click(); return }
    else return
    event.preventDefault()
    const next = items[nextIndex]
    this.updateRovingTabindex(next)
    next.focus()
    // APG radio-group keyboard model: with role="radio", arrows move focus
    // AND check the landed-on item (Home/End included).
    if (next !== event.currentTarget) next.click()
  }

  reconcile() {
    if (this.typeValue === "single") {
      // A disabled button can't take focus — never hand it the tab stop.
      const pressed = this.itemTargets.find((el) => this.isPressed(el) && !el.disabled)
      const first = pressed || this.enabledItems()[0]
      this.itemTargets.forEach((el) => el.setAttribute("tabindex", el === first ? "0" : "-1"))
    } else {
      this.itemTargets.forEach((el) => el.setAttribute("tabindex", "0"))
    }
    this.rebuildInputs()
  }

  isPressed(item) { return item.dataset.state === "on" }

  setPressed(item, pressed) {
    item.dataset.state = pressed ? "on" : "off"
    if (this.typeValue === "single") {
      item.setAttribute("aria-checked", pressed ? "true" : "false")
    } else {
      item.setAttribute("aria-pressed", pressed ? "true" : "false")
    }
  }

  updateRovingTabindex(focusedItem) {
    if (this.typeValue !== "single") return
    this.itemTargets.forEach((el) => el.setAttribute("tabindex", el === focusedItem ? "0" : "-1"))
  }

  enabledItems() { return this.itemTargets.filter((el) => !el.disabled) }

  rebuildInputs() {
    if (!this.nameValue) return
    this.inputTargets.forEach((el) => el.remove())
    const pressed = this.itemTargets.filter((el) => this.isPressed(el))
    if (this.typeValue === "single") {
      const val = pressed[0]?.dataset.value || ""
      this.element.appendChild(this.buildInput(this.nameValue, val))
    } else {
      pressed.forEach((item) => this.element.appendChild(this.buildInput(`${this.nameValue}[]`, item.dataset.value)))
    }
  }

  buildInput(name, value) {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = name
    input.value = value
    input.setAttribute("data-phlex-kit--toggle-group-target", "input")
    return input
  }
}
