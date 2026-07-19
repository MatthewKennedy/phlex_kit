import { Controller } from "@hotwired/stimulus"

const SWIPE_THRESHOLD = 45
const TIME_BEFORE_UNMOUNT = 200

// Ported from ruby_ui's toast controller (Stimulus-only upstream), identifiers and
// events renamed ruby-ui → phlex-kit; behaviour (timer, swipe, Escape) unchanged.
// Connects to data-controller="phlex-kit--toast"
export default class extends Controller {
  static values = {
    duration: { type: Number, default: 4000 },
    dismissible: { type: Boolean, default: true },
    invert: { type: Boolean, default: false },
    onDismiss: String,
    onAutoClose: String,
  }

  connect() {
    // Inherit the region's duration when this item didn't set its own: a
    // block-rendered ToastItem carries no duration-value, so without this the
    // Stimulus 4000ms default would win and ToastRegion(duration:) would be
    // dead config for block items (skeleton/flash items already stamp it).
    this._inheritRegionDuration()
    this._timer = null
    this._unmountTimer = null
    this._startedAt = 0
    this._remaining = this.durationValue
    // Independent pause sources (hover / focus / region) — resume only once
    // ALL are clear. A single shared boolean let any one source's resume
    // restart the timer while another source still held it paused (e.g.
    // pointer leaving a toast into the gap while the region is still
    // hover-paused).
    this._pauseSources = new Set()
    this._swipe = { active: false, x: 0, y: 0, startedAt: 0 }

    this._onPointerDown = this._onPointerDown.bind(this)
    this._onPointerMove = this._onPointerMove.bind(this)
    this._onPointerUp = this._onPointerUp.bind(this)
    this._onPointerEnter = () => this._pause("hover")
    this._onPointerLeave = () => { if (!this._swipe.active) this._resume("hover") }
    // Keyboard parity with hover: tabbing into the toast (e.g. to reach its
    // action button) must pause auto-dismiss just like pointerenter does.
    this._onFocusIn = (e) => {
      this._pause("focus")
      // Remember where focus came from the FIRST time it enters from outside
      // the toaster, so dismissing the last focused toast can hand focus back
      // instead of dropping it on <body>.
      const list = this.element.closest(".pk-toast-list") || this.element
      if (this._focusReturn == null && e.relatedTarget && !list.contains(e.relatedTarget)) {
        this._focusReturn = e.relatedTarget
      }
    }
    this._onFocusOut = (e) => { if (!this.element.contains(e.relatedTarget)) this._resume("focus") }
    this._onKeyDown = this._onKeyDown.bind(this)
    this._onForceDismiss = (e) => { e.stopPropagation(); this._close() }
    this._onRestart = () => this._restart()
    this._onRegionPause = () => this._pause("region")
    this._onRegionResume = () => this._resume("region")

    this.element.addEventListener("pointerdown", this._onPointerDown)
    this.element.addEventListener("pointerenter", this._onPointerEnter)
    this.element.addEventListener("pointerleave", this._onPointerLeave)
    this.element.addEventListener("focusin", this._onFocusIn)
    this.element.addEventListener("focusout", this._onFocusOut)
    this.element.addEventListener("keydown", this._onKeyDown)
    this.element.addEventListener("phlex-kit:toast:force-dismiss", this._onForceDismiss)
    this.element.addEventListener("phlex-kit:toast:restart", this._onRestart)
    // Region-scoped: the toaster dispatches pause/resume on its own list, so
    // another region's hover can't freeze (or resume) this toast's timer.
    this._regionList = this.element.closest(".pk-toast-list") || document
    this._regionList.addEventListener("phlex-kit:toast:pause", this._onRegionPause)
    this._regionList.addEventListener("phlex-kit:toast:resume", this._onRegionResume)

    this._connectFrame = requestAnimationFrame(() => {
      this._connectFrame = null
      this.element.dataset.state = "open"
      // Spawned under an already-hovered stack (the toaster stamps
      // data-pk-toasts-paused while dispatching pause): arm as paused so the
      // region's resume event starts the timer, instead of ticking away
      // under the user's cursor.
      if (Number.isFinite(this.durationValue) && this.durationValue > 0 &&
          this.element.closest("[data-pk-toasts-paused]")) {
        this._pauseSources.add("region")
        this._remaining = this.durationValue
      } else {
        this._start()
      }
    })
  }

  disconnect() {
    this._clearTimer()
    if (this._connectFrame) cancelAnimationFrame(this._connectFrame)
    this._connectFrame = null
    // Don't let a pending 200ms unmount fire after teardown (e.g. into a
    // Turbo-cached copy of the page).
    if (this._unmountTimer) clearTimeout(this._unmountTimer)
    this._unmountTimer = null
    this.element.removeEventListener("pointerdown", this._onPointerDown)
    this.element.removeEventListener("pointerenter", this._onPointerEnter)
    this.element.removeEventListener("pointerleave", this._onPointerLeave)
    this.element.removeEventListener("focusin", this._onFocusIn)
    this.element.removeEventListener("focusout", this._onFocusOut)
    this.element.removeEventListener("keydown", this._onKeyDown)
    this.element.removeEventListener("phlex-kit:toast:force-dismiss", this._onForceDismiss)
    this.element.removeEventListener("phlex-kit:toast:restart", this._onRestart)
    this._regionList?.removeEventListener("phlex-kit:toast:pause", this._onRegionPause)
    this._regionList?.removeEventListener("phlex-kit:toast:resume", this._onRegionResume)
  }

  dismiss(e) {
    e?.preventDefault()
    if (!this.dismissibleValue) return
    this._close("dismiss")
  }

  _close(reason) {
    if (this.element.dataset.state === "closing") return
    this.element.dataset.state = "closing"
    // If focus is inside this toast, move it BEFORE removal so it doesn't drop
    // to <body> when the element is gone (Escape, close button, or action).
    const hadFocus = this.element.contains(document.activeElement)
    this.element.dispatchEvent(new CustomEvent(reason === "auto" ? "phlex-kit:toast:auto-close" : "phlex-kit:toast:dismiss", { bubbles: true, detail: { id: this.element.id } }))
    this._invokeCallback(reason === "auto" ? this.onAutoCloseValue : this.onDismissValue)
    if (hadFocus) this._restoreFocusOnClose()
    this._unmountTimer = setTimeout(() => this.element.remove(), TIME_BEFORE_UNMOUNT)
  }

  // Keep keyboard focus inside the toaster when a focused toast is dismissed:
  // hand it to an adjacent remaining toast, else back to wherever focus came
  // from before it entered the toaster (tracked on first focusin).
  _restoreFocusOnClose() {
    const list = this.element.closest(".pk-toast-list")
    const others = list
      ? [...list.querySelectorAll("[data-controller~='phlex-kit--toast']")]
          .filter((t) => t !== this.element && t.dataset.state !== "closing")
      : []
    if (others.length) {
      const children = [...list.children]
      const myIdx = children.indexOf(this.element)
      const next = others.find((t) => children.indexOf(t) > myIdx) || others[others.length - 1]
      next.focus()
      return
    }
    if (this._focusReturn?.isConnected) this._focusReturn.focus()
  }

  _inheritRegionDuration() {
    if (this.element.hasAttribute("data-phlex-kit--toast-duration-value")) return
    const region = this.element.closest("[data-phlex-kit--toaster-duration-value]")
    if (!region) return
    const inherited = Number(region.getAttribute("data-phlex-kit--toaster-duration-value"))
    if (Number.isFinite(inherited)) this.durationValue = inherited
  }

  // on_dismiss:/on_auto_close: name a global function (Sonner-style callback
  // for server-rendered toasts).
  _invokeCallback(name) {
    if (!name) return
    const fn = window[name]
    if (typeof fn === "function") fn({ id: this.element.id })
  }

  _start() {
    if (!Number.isFinite(this.durationValue) || this.durationValue <= 0) return
    this._startedAt = performance.now()
    this._remaining = this.durationValue
    this._timer = setTimeout(() => this._close("auto"), this._remaining)
  }

  // Resets the timer duration but must respect any pause source still
  // active (e.g. a promise resolving into a fresh duration while the toast
  // is hovered) — arm paused instead of ticking away under the cursor, and
  // leave the source set intact so the matching resume can still fire.
  _restart() {
    this._clearTimer()
    this._remaining = this.durationValue
    if (this._pauseSources.size > 0) return
    this._start()
  }

  _pause(source) {
    this._pauseSources.add(source)
    if (!this._timer) return
    clearTimeout(this._timer)
    this._timer = null
    this._remaining -= performance.now() - this._startedAt
  }

  _resume(source) {
    this._pauseSources.delete(source)
    if (this._pauseSources.size > 0) return
    if (this._timer) return
    if (!Number.isFinite(this.durationValue) || this.durationValue <= 0) return
    if (this._remaining <= 0) return this._close("auto")
    this._startedAt = performance.now()
    this._timer = setTimeout(() => this._close("auto"), this._remaining)
  }

  _clearTimer() {
    if (this._timer) clearTimeout(this._timer)
    this._timer = null
  }

  _onKeyDown(e) {
    if (e.key === "Escape" && this.dismissibleValue) this.dismiss(e)
  }

  _onPointerDown(e) {
    if (!this.dismissibleValue) return
    if (e.target.closest("button")) return
    try { this.element.setPointerCapture(e.pointerId) } catch {}
    this._swipe = { active: true, x: e.clientX, y: e.clientY, startedAt: performance.now(), pointerId: e.pointerId }
    this.element.dataset.swipe = "start"
    this.element.addEventListener("pointermove", this._onPointerMove)
    this.element.addEventListener("pointerup", this._onPointerUp)
    this.element.addEventListener("pointercancel", this._onPointerUp)
  }

  _onPointerMove(e) {
    const dx = e.clientX - this._swipe.x
    const dy = e.clientY - this._swipe.y
    this.element.dataset.swipe = "move"
    // Never write style.transform here: the toaster owns it (stacking
    // translate3d + scale, written to compose these vars). Writing it
    // directly snapped non-front toasts out of position.
    this.element.style.setProperty("--pk-toast-swipe-x", `${dx}px`)
    this.element.style.setProperty("--pk-toast-swipe-y", `${dy}px`)
  }

  _onPointerUp(e) {
    const dx = e.clientX - this._swipe.x
    const dy = e.clientY - this._swipe.y
    const dist = Math.hypot(dx, dy)
    const dt = performance.now() - this._swipe.startedAt
    const velocity = dist / Math.max(dt, 1)
    this.element.removeEventListener("pointermove", this._onPointerMove)
    this.element.removeEventListener("pointerup", this._onPointerUp)
    this.element.removeEventListener("pointercancel", this._onPointerUp)
    this._swipe.active = false
    if (dist > SWIPE_THRESHOLD || velocity > 0.5) {
      // Keep the swipe vars in place: they are the animation's start point.
      // toast.css's [data-swipe="end"] keyframes fly the toast out along
      // --swipe-end-x/y while _close fades + removes it.
      this.element.style.setProperty("--swipe-end-x", `${Math.sign(dx) * 500}px`)
      this.element.style.setProperty("--swipe-end-y", `${Math.sign(dy) * 500}px`)
      this.element.dataset.swipe = "end"
      this._close("dismiss")
    } else {
      // Clearing the vars composes the toast back into the toaster's stacking
      // transform; the transition (re-enabled once data-swipe leaves "move")
      // animates it home.
      this.element.dataset.swipe = "cancel"
      this.element.style.removeProperty("--pk-toast-swipe-x")
      this.element.style.removeProperty("--pk-toast-swipe-y")
      // pointerleave is suppressed while a swipe is active, so release the
      // hover hold here — but only if the pointer actually left the toast; a
      // cancelled swipe ending under the cursor must stay hover-paused (the
      // eventual pointerleave resumes it, including the touch case where
      // pointerleave fires right after pointerup).
      if (!this.element.matches(":hover")) this._resume("hover")
    }
  }
}
