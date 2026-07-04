import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--sidebar" — set by SidebarWrapper when
// collapsible: :offcanvas. One attribute per surface, both DOM-only so Turbo's
// page cache never restores an open drawer (the wrapper also closes on
// turbo:before-cache): `data-open` shows the mobile overlay drawer,
// `data-collapsed` slides the desktop rail out of the layout. The 767px cutoff
// matches sidebar.css's offcanvas media query.
export default class extends Controller {
  static MOBILE = "(max-width: 767px)"

  toggle() {
    if (this.mobile) this.element.toggleAttribute("data-open")
    else this.element.toggleAttribute("data-collapsed")
  }

  closeMobile() {
    this.element.removeAttribute("data-open")
  }

  get mobile() {
    return window.matchMedia(this.constructor.MOBILE).matches
  }
}
