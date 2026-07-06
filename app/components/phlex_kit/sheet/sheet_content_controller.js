import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--sheet-content" (on the cloned node —
// drawers ride the same machinery). Owns the modal contract for the open panel:
// scroll lock, initial focus, Tab focus trap, Escape-to-close, focus restore to
// the opener, and aria-labelledby wiring to the SheetTitle/DrawerTitle. connect
// and disconnect exactly bracket the clone's lifetime, so removal by any path
// (close button, backdrop, Escape, turbo:before-cache) restores state.
const FOCUSABLE =
  'a[href], button:not([disabled]), input:not([disabled]), select, textarea, [tabindex]:not([tabindex="-1"])'

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    this.opener = document.activeElement
    this.previousOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"
    this.#wireAriaLabelledby()
    const focusables = this.#focusables()
    ;(focusables[0] || this.panel).focus()
  }

  disconnect() {
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

  #wireAriaLabelledby() {
    if (this.panel.getAttribute("aria-labelledby")) return
    const title = this.element.querySelector(".pk-sheet-title, .pk-drawer-title")
    if (!title) return
    if (!title.id) title.id = `pk-modal-title-${Math.random().toString(36).slice(2, 10)}`
    this.panel.setAttribute("aria-labelledby", title.id)
  }
}
