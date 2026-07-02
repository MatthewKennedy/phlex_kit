import { Controller } from "@hotwired/stimulus"

// Drives the .pk-scroll-fade utility (shadcn's scroll-fade): toggles
// data-at-start/data-at-end so the edge masks only show where more content
// exists in that direction.
// Connects to data-controller="phlex-kit--scroll-fade"
export default class extends Controller {
  connect() {
    this._onScroll = () => this.update()
    this.element.addEventListener("scroll", this._onScroll, { passive: true })
    this.update()
  }

  disconnect() {
    this.element.removeEventListener("scroll", this._onScroll)
  }

  update() {
    const el = this.element
    el.toggleAttribute("data-at-start", el.scrollTop <= 1)
    el.toggleAttribute("data-at-end", el.scrollTop + el.clientHeight >= el.scrollHeight - 1)
  }
}
