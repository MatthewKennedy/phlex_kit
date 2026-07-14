import { Controller } from "@hotwired/stimulus"

// PhlexKit's stand-in for react-resizable-panels behind shadcn's Resizable:
// dragging (or arrow-keying) a handle rebalances the flex-grow of the two
// panels around it. The handle is a focusable role="separator", so it also
// carries the ARIA value contract: aria-valuenow tracks the leading panel's
// share of the pair, and aria-orientation follows the group direction (a
// handle in a horizontal group is a vertical separator).
// Connects to data-controller="phlex-kit--resizable"
export default class extends Controller {
  static targets = ["panel", "handle"]
  static values = { direction: { type: String, default: "horizontal" } }

  disconnect() {
    // a disconnect mid-drag must drop the handle's move/up listeners
    if (this._activeDrag) {
      const { handle, onMove, onUp } = this._activeDrag
      handle.removeEventListener("pointermove", onMove)
      handle.removeEventListener("pointerup", onUp)
      handle.removeEventListener("pointercancel", onUp)
      this._activeDrag = null
    }
  }

  handleTargetConnected(handle) {
    handle.setAttribute("aria-orientation", this.directionValue === "horizontal" ? "vertical" : "horizontal")
    handle.setAttribute("aria-valuemin", "0")
    handle.setAttribute("aria-valuemax", "100")
    this.syncValuenow(handle)
  }

  start(e) {
    if (e.button !== 0 || !e.isPrimary) return
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
      // The drag redistributes the PAIR's combined flex-grow, not a fixed
      // constant: normalizing to 2 rescaled the pair against untouched
      // siblings, so in a 25/25/50 group the 50 panel ballooned on first drag.
      pairGrow: this.growOf(prev) + this.growOf(next) || 2,
    }
    try { handle.setPointerCapture(e.pointerId) } catch {}

    const onMove = (ev) => {
      const delta = (horizontal ? ev.clientX : ev.clientY) - drag.startPos
      const total = drag.prevSize + drag.nextSize
      const prevSize = Math.min(Math.max(drag.prevSize + delta, 0), total)
      prev.style.flexGrow = (prevSize / total) * drag.pairGrow
      next.style.flexGrow = ((total - prevSize) / total) * drag.pairGrow
      this.syncValuenow(handle)
    }
    const onUp = () => {
      handle.removeEventListener("pointermove", onMove)
      handle.removeEventListener("pointerup", onUp)
      handle.removeEventListener("pointercancel", onUp)
      this._activeDrag = null
    }
    handle.addEventListener("pointermove", onMove)
    handle.addEventListener("pointerup", onUp)
    handle.addEventListener("pointercancel", onUp)
    this._activeDrag = { handle, onMove, onUp } // for disconnect() cleanup
  }

  // Arrow keys resize by 5% of the pair per press (matching the drag axis);
  // Home/End collapse the leading panel to its min/max.
  keydown(e) {
    const handle = e.currentTarget
    const prev = handle.previousElementSibling
    const next = handle.nextElementSibling
    if (!prev || !next) return

    const horizontal = this.directionValue === "horizontal"
    const steps = horizontal
      ? { ArrowLeft: -0.05, ArrowRight: 0.05 }
      : { ArrowUp: -0.05, ArrowDown: 0.05 }

    const pairGrow = this.growOf(prev) + this.growOf(next) || 2
    let share = this.growOf(prev) / (pairGrow || 1)
    if (e.key in steps) {
      share = Math.min(1, Math.max(0, share + steps[e.key]))
    } else if (e.key === "Home") {
      share = 0
    } else if (e.key === "End") {
      share = 1
    } else {
      return
    }
    e.preventDefault()

    prev.style.flexGrow = share * pairGrow
    next.style.flexGrow = (1 - share) * pairGrow
    this.syncValuenow(handle)
  }

  growOf(el) {
    const g = parseFloat(getComputedStyle(el).flexGrow)
    return Number.isFinite(g) ? g : 1
  }

  syncValuenow(handle) {
    const prev = handle.previousElementSibling
    const next = handle.nextElementSibling
    if (!prev || !next) return
    const pair = this.growOf(prev) + this.growOf(next)
    const share = pair > 0 ? this.growOf(prev) / pair : 0.5
    handle.setAttribute("aria-valuenow", String(Math.round(share * 100)))
  }
}
