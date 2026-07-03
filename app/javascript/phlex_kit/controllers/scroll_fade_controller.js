import { Controller } from "@hotwired/stimulus"

// Drives the .pk-scroll-fade utility (shadcn's scroll-fade): toggles
// data-at-start/data-at-end so the edge masks only show where more content
// exists in that direction. axis value "y" (default) or "x" — AttachmentGroup
// uses horizontal mode.
// Connects to data-controller="phlex-kit--scroll-fade"
export default class extends Controller {
  static values = { axis: { type: String, default: "y" } }

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
    if (this.axisValue === "x") {
      el.toggleAttribute("data-at-start", el.scrollLeft <= 1)
      el.toggleAttribute("data-at-end", el.scrollLeft + el.clientWidth >= el.scrollWidth - 1)
    } else {
      el.toggleAttribute("data-at-start", el.scrollTop <= 1)
      el.toggleAttribute("data-at-end", el.scrollTop + el.clientHeight >= el.scrollHeight - 1)
    }
  }
}
