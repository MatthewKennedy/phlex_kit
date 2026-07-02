import { Controller } from "@hotwired/stimulus"

// PhlexKit's stand-in for react-resizable-panels behind shadcn's Resizable:
// dragging a handle rebalances the flex-grow of the two panels around it.
// Connects to data-controller="phlex-kit--resizable"
export default class extends Controller {
  static targets = ["panel", "handle"]
  static values = { direction: { type: String, default: "horizontal" } }

  start(e) {
    const handle = e.currentTarget
    const prev = handle.previousElementSibling
    const next = handle.nextElementSibling
    if (!prev || !next) return
    e.preventDefault()

    const horizontal = this.directionValue === "horizontal"
    const sizeOf = (el) => horizontal ? el.getBoundingClientRect().width : el.getBoundingClientRect().height
    const drag = {
      startPos: horizontal ? e.clientX : e.clientY,
      prevSize: sizeOf(prev),
      nextSize: sizeOf(next),
    }
    try { handle.setPointerCapture(e.pointerId) } catch {}

    const onMove = (ev) => {
      const delta = (horizontal ? ev.clientX : ev.clientY) - drag.startPos
      const total = drag.prevSize + drag.nextSize
      const prevSize = Math.min(Math.max(drag.prevSize + delta, 0), total)
      prev.style.flexGrow = (prevSize / total) * 2
      next.style.flexGrow = ((total - prevSize) / total) * 2
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
