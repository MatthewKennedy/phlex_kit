import { Controller } from "@hotwired/stimulus"

// The tooltip stays CSS-revealed (:hover/:focus-within, tooltip.css) — this
// controller only adds what CSS can't: aria-describedby wiring from trigger
// to bubble, and WCAG 1.4.13 Escape-dismiss (data-pk-dismissed suppresses the
// bubble until the pointer/focus leaves the wrapper).
// Connects to data-controller="phlex-kit--tooltip"
export default class extends Controller {
  connect() {
    const content = this.element.querySelector(".pk-tooltip-content")
    const trigger = this.element.querySelector(".pk-tooltip-trigger")
    if (content && trigger) {
      if (!content.id) content.id = `pk-tooltip-${Math.random().toString(36).slice(2, 8)}`
      // Describe the element that actually takes focus: with focusable: false
      // the wrapper span never receives focus, so a describedby left only on
      // it is never announced — wire the focusable child too.
      const focusable = trigger.querySelector("button, a[href], input, select, textarea, [tabindex]")
      ;[trigger, focusable].forEach((el) => {
        if (el && !el.hasAttribute("aria-describedby")) el.setAttribute("aria-describedby", content.id)
      })
    }

    // connect() re-derives reflected state from live truth: a Turbo snapshot
    // serializes an Escape-dismissed suppression, and a cache restore must
    // not resurrect it (the pointer/focus that justified it is gone).
    delete this.element.dataset.pkDismissed

    this._onKeydown = (e) => {
      if (e.key !== "Escape") return
      if (this.element.matches(":hover, :focus-within")) this.element.dataset.pkDismissed = ""
    }
    this._reset = () => delete this.element.dataset.pkDismissed
    window.addEventListener("keydown", this._onKeydown)
    this.element.addEventListener("pointerleave", this._reset)
    this.element.addEventListener("focusout", this._reset)
  }

  disconnect() {
    window.removeEventListener("keydown", this._onKeydown)
    this.element.removeEventListener("pointerleave", this._reset)
    this.element.removeEventListener("focusout", this._reset)
  }
}
