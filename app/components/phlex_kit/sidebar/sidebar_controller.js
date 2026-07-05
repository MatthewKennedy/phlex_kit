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
export default class extends Controller {
  static MOBILE = "(max-width: 767px)"
  static COOKIE = "pk_sidebar_state"

  toggle(event) {
    if (event?.type === "keydown" && !(event.metaKey || event.ctrlKey)) return

    if (this.mobile) {
      this.element.toggleAttribute("data-open")
    } else {
      this.element.toggleAttribute("data-collapsed")
      this.persist()
    }
  }

  closeMobile() {
    this.element.removeAttribute("data-open")
  }

  persist() {
    const state = this.element.hasAttribute("data-collapsed") ? "collapsed" : "expanded"
    document.cookie = `${this.constructor.COOKIE}=${state}; path=/; max-age=${60 * 60 * 24 * 7}; samesite=lax`
  }

  get mobile() {
    return window.matchMedia(this.constructor.MOBILE).matches
  }
}
