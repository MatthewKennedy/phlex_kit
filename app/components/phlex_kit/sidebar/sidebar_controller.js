import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--sidebar" — set by SidebarWrapper when
// collapsible: :offcanvas or :icon. One attribute per surface, both DOM-only so
// Turbo's page cache never restores an open drawer (the wrapper also closes on
// turbo:before-cache): `data-open` shows the mobile overlay drawer,
// `data-collapsed` collapses the desktop rail (offcanvas slides it away; icon
// mode shrinks it to a 3rem strip). The 767px cutoff matches sidebar.css's
// media query. The desktop state persists in a `pk_sidebar_state` cookie so a
// host layout can render the collapsed rail server-side (no flash) via
// SidebarWrapper's `default_collapsed:`.
//
// A11y: connect() wires aria-controls on every trigger/rail that didn't get one
// server-side (generating an id on the .pk-sidebar if needed) and keeps their
// aria-expanded in sync on every toggle. The mobile overlay drawer is a real
// modal: opening moves focus into it and inerts the rest of the wrapper + page
// (the scrim stays live — it IS the close control), closing (scrim, Escape,
// trigger, turbo:before-cache) restores inert state and returns focus to the
// opener.
const FOCUSABLE =
  'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'

export default class extends Controller {
  static MOBILE = "(max-width: 767px)"
  static COOKIE = "pk_sidebar_state"

  connect() {
    // Crossing to desktop while the mobile drawer is open would strand the
    // page inert: the scrim/drawer CSS stops applying at >=768px but the
    // inert marks (and data-open) would survive. Close on breakpoint change.
    this.mql = window.matchMedia(this.constructor.MOBILE)
    this.onBreakpoint = () => {
      if (!this.mql.matches) this.closeMobile()
      this.#syncExpanded()
    }
    this.mql.addEventListener("change", this.onBreakpoint)
    this.#wireAriaControls()
    this.#syncExpanded()
  }

  disconnect() {
    this.mql.removeEventListener("change", this.onBreakpoint)
    this.#restoreInert()
  }

  toggle(event) {
    if (event?.type === "keydown" && !(event.metaKey || event.ctrlKey)) return

    if (this.mobile) {
      if (this.element.hasAttribute("data-open")) {
        this.closeMobile()
      } else {
        this.element.setAttribute("data-open", "")
        this.#trapMobile(event)
      }
    } else {
      this.element.toggleAttribute("data-collapsed")
      this.persist()
    }
    this.#syncExpanded()
  }

  closeMobile() {
    if (!this.element.hasAttribute("data-open")) return
    this.element.removeAttribute("data-open")
    this.#restoreInert()
    if (this.opener?.isConnected) this.opener.focus()
    this.opener = null
    this.#syncExpanded()
  }

  persist() {
    const state = this.element.hasAttribute("data-collapsed") ? "collapsed" : "expanded"
    document.cookie = `${this.constructor.COOKIE}=${state}; path=/; max-age=${60 * 60 * 24 * 7}; samesite=lax`
  }

  get mobile() {
    return window.matchMedia(this.constructor.MOBILE).matches
  }

  get sidebar() {
    return this.element.querySelector(".pk-sidebar")
  }

  get togglers() {
    return this.element.querySelectorAll(".pk-sidebar-trigger, .pk-sidebar-rail")
  }

  // Open mobile drawer: remember the opener, inert everything that isn't the
  // sidebar or its scrim, and move focus into the drawer.
  #trapMobile(event) {
    this.opener = event?.currentTarget instanceof HTMLElement ? event.currentTarget : document.activeElement
    this.#inertOthers()
    const sidebar = this.sidebar
    if (!sidebar) return
    const focusable = sidebar.querySelector(FOCUSABLE)
    ;(focusable || sidebar).focus()
  }

  // Inert the page behind the scrim: the wrapper's siblings in <body>, plus
  // wrapper children other than the sidebar and the scrim (typically the
  // SidebarInset). Prior inert state is saved per element and restored on
  // close/disconnect (turbo:before-cache routes through closeMobile).
  #inertOthers() {
    this.inerted = []
    const skip = ["SCRIPT", "STYLE", "LINK", "TEMPLATE"]
    const mark = (el) => {
      if (skip.includes(el.tagName)) return
      this.inerted.push([el, el.inert])
      el.inert = true
    }
    for (const el of document.body.children) {
      if (el === this.element || el.contains(this.element)) continue
      mark(el)
    }
    for (const el of this.element.children) {
      if (el.matches(".pk-sidebar, .pk-sidebar-scrim")) continue
      mark(el)
    }
  }

  #restoreInert() {
    for (const [el, wasInert] of this.inerted || []) el.inert = wasInert
    this.inerted = null
  }

  // aria-controls: point every trigger/rail at the sidebar's id (server-side
  // `controls:` wins; an id is generated when the sidebar has none).
  #wireAriaControls() {
    const sidebar = this.sidebar
    if (!sidebar) return
    if (!sidebar.id) sidebar.id = `pk-sidebar-${Math.random().toString(36).slice(2, 10)}`
    for (const el of this.togglers) {
      if (!el.getAttribute("aria-controls")) el.setAttribute("aria-controls", sidebar.id)
    }
  }

  // aria-expanded mirrors the surface the viewport is actually showing:
  // the mobile drawer's data-open below the cutoff, data-collapsed above it.
  #syncExpanded() {
    const expanded = this.mobile
      ? this.element.hasAttribute("data-open")
      : !this.element.hasAttribute("data-collapsed")
    for (const el of this.togglers) el.setAttribute("aria-expanded", String(expanded))
  }
}
