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
    this.restored = false
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
    this.restoreImmediate()
  }

  // Synchronously undoes everything connect() did: background inert,
  // scroll lock, and the closed-notification to the source sheet
  // controller. Called from disconnect() (the normal removal path) AND
  // from the source phlex-kit--sheet controller's turbo:before-cache
  // handler, which must restore state before Turbo's synchronous snapshot
  // — disconnect() fires via MutationObserver, too late for that snapshot.
  // Idempotent (guarded by `this.restored`) so whichever path runs second
  // is a harmless no-op.
  restoreImmediate() {
    if (this.restored) return
    this.restored = true
    this.#restoreInert()
    document.body.style.overflow = this.previousOverflow
    if (this.opener?.isConnected) this.opener.focus()
    // Tell the source phlex-kit--sheet controller the clone is gone so it
    // can flip the trigger's aria-expanded back (removal happens by many
    // paths: close button, Escape, backdrop, before-cache).
    document.dispatchEvent(new CustomEvent("phlex-kit:sheet-content:closed"))
  }

  close() {
    this.element.remove()
  }

  // Backdrop mousedown would move focus to <body>, killing this
  // element-scoped keydown listener (Escape after a drag-off-backdrop would
  // stop working) — prevented here so focus stays inside the panel. The
  // backdrop's click->close action still fires normally afterward.
  overlayMousedown(event) {
    event.preventDefault()
  }

  keydown(event) {
    // A native <dialog> nested inside this panel (e.g. a Dialog opened from
    // within SheetContent) owns its own Escape handling; the keydown still
    // bubbles through this element-scoped listener since dialog is a DOM
    // descendant — ignore it so one Escape doesn't also close the sheet
    // underneath.
    if (event.key === "Escape" && event.target.closest("dialog[open]")) return
    if (event.key === "Escape") {
      event.preventDefault()
      // Stop the keydown from reaching a lower/outer overlay's own
      // document-level Escape listener (e.g. an alert_dialog this sheet is
      // stacked on top of) — this element-scoped listener runs first during
      // bubbling, and by the time a document-level listener would see it,
      // this.close() has already removed the [data-pk-overlay-clone] marker
      // the other overlay's #topmost() check relies on.
      event.stopPropagation()
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
