import { Controller } from "@hotwired/stimulus"

// PhlexKit's stand-in for react-resizable-panels behind shadcn's Resizable:
// dragging a handle rebalances the flex-grow of the two panels around it.
// Connects to data-controller="phlex-kit--resizable"
export default class extends Controller {
  static targets = ["panel", "handle"]
  static values = { direction: { type: String, default: "horizontal" } }

  start(e) {
    if (e.button !== 0 || !e.isPrimary) return
    const handle = e.currentTarget
    const prev = handle.previousElementSibling
    const next = handle.nextElementSibling
    if (!prev || !next) return
    e.preventDefault()

    const horizontal = this.directionValue === "horizontal"
    const sizeOf = (el) => horizontal ? el.getBoundingClientRect().width : el.getBoundingClientRect().height
    const growOf = (el) => {
      const g = parseFloat(getComputedStyle(el).flexGrow)
      return Number.isFinite(g) ? g : 1
    }
    const drag = {
      startPos: horizontal ? e.clientX : e.clientY,
      prevSize: sizeOf(prev),
      nextSize: sizeOf(next),
      // The drag redistributes the PAIR's combined flex-grow, not a fixed
      // constant: normalizing to 2 rescaled the pair against untouched
      // siblings, so in a 25/25/50 group the 50 panel ballooned on first drag.
      pairGrow: growOf(prev) + growOf(next) || 2,
    }
    try { handle.setPointerCapture(e.pointerId) } catch {}

    const onMove = (ev) => {
      const delta = (horizontal ? ev.clientX : ev.clientY) - drag.startPos
      const total = drag.prevSize + drag.nextSize
      const prevSize = Math.min(Math.max(drag.prevSize + delta, 0), total)
      prev.style.flexGrow = (prevSize / total) * drag.pairGrow
      next.style.flexGrow = ((total - prevSize) / total) * drag.pairGrow
    }
    const onUp = () => {
      handle.removeEventListener("pointermove", onMove)
      handle.removeEventListener("pointerup", onUp)
      handle.removeEventListener("pointercancel", onUp)
    }
    handle.addEventListener("pointermove", onMove)
    handle.addEventListener("pointerup", onUp)
    handle.addEventListener("pointercancel", onUp)
  }
}
