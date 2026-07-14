import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--sheet-content" (on the cloned node —
// drawers ride the same machinery). Owns the modal contract for the open panel:
// scroll lock, background inert, initial focus, Tab focus trap, Escape-to-close,
// focus restore to the opener, and aria-labelledby/-describedby wiring to the
// Sheet/Drawer Title + Description. connect and disconnect exactly bracket the
// clone's lifetime, so removal by any path (close button, backdrop, Escape,
// turbo:before-cache — the phlex-kit--sheet source controller removes the clone
// there) restores state.
const FOCUSABLE =
  'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    this.opener = document.activeElement
    this.previousOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"
    this.#inertOthers()
    this.#wireAria("aria-labelledby", ".pk-sheet-title, .pk-drawer-title")
    this.#wireAria("aria-describedby", ".pk-sheet-description, .pk-drawer-description")
    const focusables = this.#focusables()
    ;(focusables[0] || this.panel).focus()
  }

  disconnect() {
    this.#restoreInert()
    document.body.style.overflow = this.previousOverflow
    if (this.opener?.isConnected) this.opener.focus()
  }

  close() {
    this.element.remove()
  }

  keydown(event) {
    if (event.key === "Escape") {
      event.preventDefault()
      this.close()
      return
    }
    if (event.key !== "Tab") return
    const focusables = this.#focusables()
    if (focusables.length === 0) {
      event.preventDefault()
      this.panel.focus()
      return
    }
    const first = focusables[0]
    const last = focusables[focusables.length - 1]
    if (event.shiftKey && (document.activeElement === first || document.activeElement === this.panel)) {
      event.preventDefault()
      last.focus()
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault()
      first.focus()
    }
  }

  get panel() {
    return this.hasPanelTarget ? this.panelTarget : this.element
  }

  #focusables() {
    return [...this.panel.querySelectorAll(FOCUSABLE)].filter((el) => el.getClientRects().length > 0)
  }

  // Make everything behind the panel inert (the clone is <body>'s last child,
  // so its siblings are the whole page). Prior inert state is saved per
  // element and restored on disconnect — which fires on every removal path,
  // including the source controller's turbo:before-cache cleanup.
  #inertOthers() {
    this.inerted = []
    for (const el of document.body.children) {
      if (el === this.element) continue
      if (["SCRIPT", "STYLE", "LINK", "TEMPLATE"].includes(el.tagName)) continue
      this.inerted.push([el, el.inert])
      el.inert = true
    }
  }

  #restoreInert() {
    for (const [el, wasInert] of this.inerted || []) el.inert = wasInert
    this.inerted = null
  }

  #wireAria(attr, selector) {
    if (this.panel.getAttribute(attr)) return
    const el = this.element.querySelector(selector)
    if (!el) return
    if (!el.id) el.id = `pk-modal-${attr.slice(5)}-${Math.random().toString(36).slice(2, 10)}`
    this.panel.setAttribute(attr, el.id)
  }
}
