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
    // preventDefault suppresses mouse-driven focus — hand it to the handle
    // so a drag can be fine-tuned with the arrow keys immediately.
    handle.focus({ preventScroll: true })

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
      // Snapshot the group's total grow: min/max-size percentages are shares
      // of the WHOLE group, and untouched siblings keep their grow mid-drag.
      groupGrow: this.groupGrow(),
    }
    try { handle.setPointerCapture(e.pointerId) } catch {}

    const onMove = (ev) => {
      // LTR assumption: clientX grows toward the trailing panel; RTL drag
      // inversion is a documented limitation.
      const delta = (horizontal ? ev.clientX : ev.clientY) - drag.startPos
      const total = drag.prevSize + drag.nextSize
      const prevSize = Math.min(Math.max(drag.prevSize + delta, 0), total)
      const prevGrow = this.clampPrevGrow(prev, next, (prevSize / total) * drag.pairGrow, drag.pairGrow, drag.groupGrow)
      prev.style.flexGrow = prevGrow
      next.style.flexGrow = drag.pairGrow - prevGrow
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
  // Home/End collapse the leading panel to its min/max (clamped to any
  // per-panel min-size/max-size bounds, same as drags).
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

    const prevGrow = this.clampPrevGrow(prev, next, share * pairGrow, pairGrow, this.groupGrow())
    prev.style.flexGrow = prevGrow
    next.style.flexGrow = pairGrow - prevGrow
    this.syncValuenow(handle)
  }

  growOf(el) {
    const g = parseFloat(getComputedStyle(el).flexGrow)
    return Number.isFinite(g) ? g : 1
  }

  // Clamp the leading panel's proposed flex-grow to both panels' optional
  // min-size/max-size percentages. Bounds are shares of the whole group
  // (grow / groupGrow), and the pair's combined grow is fixed, so a bound on
  // one panel implies the complementary bound on its neighbour. Without any
  // bounds this collapses to the historical [0, pairGrow] clamp.
  clampPrevGrow(prev, next, prevGrow, pairGrow, groupGrow) {
    const pb = this.boundsOf(prev)
    const nb = this.boundsOf(next)
    let lo = 0
    let hi = pairGrow
    if (pb.min !== null) lo = Math.max(lo, pb.min * groupGrow)
    if (nb.max !== null) lo = Math.max(lo, pairGrow - nb.max * groupGrow)
    if (pb.max !== null) hi = Math.min(hi, pb.max * groupGrow)
    if (nb.min !== null) hi = Math.min(hi, pairGrow - nb.min * groupGrow)
    if (lo > hi) return Math.min(Math.max(prevGrow, 0), pairGrow) // unsatisfiable bounds: ignore them
    return Math.min(Math.max(prevGrow, lo), hi)
  }

  // A panel's declared size bounds as fractions of the group, or nulls.
  boundsOf(el) {
    const min = parseFloat(el.getAttribute("data-phlex-kit--resizable-min-size"))
    const max = parseFloat(el.getAttribute("data-phlex-kit--resizable-max-size"))
    return {
      min: Number.isFinite(min) ? min / 100 : null,
      max: Number.isFinite(max) ? max / 100 : null,
    }
  }

  // Combined flex-grow of this group's own panels (direct children only —
  // panels of a nested group belong to that group's own controller).
  groupGrow() {
    return [...this.element.children]
      .filter((el) => el.matches('[data-phlex-kit--resizable-target~="panel"]'))
      .reduce((sum, el) => sum + this.growOf(el), 0) || 2
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
