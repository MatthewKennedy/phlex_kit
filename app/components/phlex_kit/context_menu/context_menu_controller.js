import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--context-menu". Opens at the cursor
// on contextmenu (at the trigger's rect for the keyboard Menu key / Shift+F10,
// which fire with clientX/Y of 0) and focuses the first item; ArrowDown/
// ArrowUp/Home/End rove over the items (skipping [data-disabled]); closes on
// outside click or Escape, returning focus to the trigger. CSS positioning
// (no floating-ui).
export default class extends Controller {
  static targets = ["content", "trigger", "menuItem"]

  connect() {
    this.onDoc = (e) => { if (!this.contentTarget.contains(e.target)) this.close() }
    this.onKey = (e) => this.keydown(e)
  }

  disconnect() {
    document.removeEventListener("click", this.onDoc)
    document.removeEventListener("keydown", this.onKey)
  }

  open(e) {
    e.preventDefault()
    const r = this.element.getBoundingClientRect()
    let x = e.clientX
    let y = e.clientY
    if (x === 0 && y === 0) {
      const t = this.anchor().getBoundingClientRect()
      x = t.left
      y = t.bottom
    }
    this.contentTarget.style.left = `${x - r.left}px`
    this.contentTarget.style.top = `${y - r.top}px`
    this.contentTarget.classList.remove("pk-hidden")
    this.contentTarget.dataset.state = "open"
    document.addEventListener("click", this.onDoc)
    document.addEventListener("keydown", this.onKey)
    this.items()[0]?.focus()
  }

  close(opts = {}) {
    this.contentTarget.classList.add("pk-hidden")
    this.contentTarget.dataset.state = "closed"
    document.removeEventListener("click", this.onDoc)
    document.removeEventListener("keydown", this.onKey)
    if (opts.refocus === true) this.anchor().focus()
  }

  keydown(e) {
    const items = this.items()
    const index = items.indexOf(document.activeElement)
    switch (e.key) {
      case "Escape":
        e.preventDefault()
        this.close({ refocus: true })
        break
      case "ArrowDown":
        e.preventDefault()
        items[(index + 1) % items.length]?.focus()
        break
      case "ArrowUp":
        e.preventDefault()
        items[index < 0 ? items.length - 1 : (index - 1 + items.length) % items.length]?.focus()
        break
      case "Home":
        e.preventDefault()
        items[0]?.focus()
        break
      case "End":
        e.preventDefault()
        items[items.length - 1]?.focus()
        break
    }
  }

  anchor() {
    return this.hasTriggerTarget ? this.triggerTarget : this.element
  }

  items() {
    return this.menuItemTargets.filter((el) => !el.closest("[data-disabled]") && !el.closest(".pk-hidden"))
  }
}
