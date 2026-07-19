import { Controller } from "@hotwired/stimulus"

const VARIANTS = ["default", "success", "error", "warning", "info", "loading"]

let streamActionRegistered = false

function registerStreamAction() {
  if (streamActionRegistered) return
  if (typeof window === "undefined") return
  const Turbo = window.Turbo
  if (!Turbo?.StreamActions) return
  Turbo.StreamActions.toast = function () {
    const detail = {}
    for (const attr of this.attributes) {
      if (attr.name === "action" || attr.name === "target" || attr.name === "targets") continue
      detail[attr.name] = attr.value
    }
    if (detail.duration != null && detail.duration !== "") detail.duration = Number(detail.duration)
    if (detail.dismissible != null) detail.dismissible = detail.dismissible !== "false"
    window.dispatchEvent(new CustomEvent("phlex-kit:toast", { detail }))
  }
  streamActionRegistered = true
}

// Ported from ruby_ui's toaster controller (Stimulus-only upstream) with identifiers,
// events and the window API renamed ruby-ui/RubyUI → phlex-kit/PhlexKit, and the
// Tailwind pr-10 spawn class swapped for .pk-toast-with-close (toast.css).
// Connects to data-controller="phlex-kit--toaster"
export default class extends Controller {
  static targets = ["skeleton", "toast", "actionTpl", "cancelTpl", "closeTpl"]
  static values = {
    position: { type: String, default: "bottom-right" },
    expand: { type: Boolean, default: false },
    max: { type: Number, default: 3 },
    duration: { type: Number, default: 4000 },
    gap: { type: Number, default: 14 },
    // offset is a CSS custom property (--pk-toast-offset) and dir a real
    // dir attribute, both stamped by ToastRegion; theme/richColors are
    // unsupported (region raises) — none of them are controller state.
    hotkey: { type: String, default: "alt+t" },
  }

  // State the target callbacks touch lives here, NOT in connect(): Stimulus
  // fires toastTargetConnected() BEFORE connect() for toasts already in the
  // HTML (server-rendered flash), and upstream's connect()-time init crashes
  // on that path.
  initialize() {
    this._heights = new Map()
    this._resizeObservers = new WeakMap()
    this._expanded = false
    this._paused = false
  }

  connect() {
    this._expanded = this.expandValue
    this._listEl = this.element.querySelector("ol") || (this.element.tagName === "OL" ? this.element : null)
    this._registerGlobalApi()
    registerStreamAction()
    if (!this._listEl) return

    // Pause/resume tracks the POINTER, not the expand transition: an
    // expand:true region is born expanded, and tying the pause dispatch to
    // _setExpanded's state change left auto-dismiss running under the cursor.
    this._onPointerEnter = () => { this._setPaused(true); this._setExpanded(true) }
    this._onPointerLeave = () => { this._setPaused(false); if (!this.expandValue) this._setExpanded(false) }
    this._onWindowToast = (e) => {
      const detail = e.detail || {}
      // Routing: toast(msg, { region: "<id>" }) targets the region whose
      // wrapper or list carries that id. Without region only the page's
      // FIRST region spawns — the event is a window broadcast, so every
      // region hears it and an unguarded spawn would duplicate the toast
      // once per region.
      if (!this._handlesRegion(detail.region)) return
      this._spawn(detail)
    }
    this._onWindowDismissAll = () => this._dismissById(null)
    // Dismiss-by-id is a broadcast too: _dismissById only acts on a toast in
    // its OWN list, so whichever region owns the id handles it — the api
    // registration (last region wins) no longer has to be the owner.
    this._onWindowDismissId = (e) => this._dismissById(e.detail?.id)
    this._onKey = this._onKey.bind(this)

    // The region is data-turbo-permanent (in-flight toasts survive a Turbo
    // Drive visit), but that means Turbo KEEPS this old region and DISCARDS
    // the incoming page's — throwing away any server-rendered flash toasts it
    // holds. Adopt them into this permanent list before the transplant so
    // flash: works on Turbo Drive visits, not only full page loads.
    this._onBeforeRender = (e) => this._adoptIncomingToasts(e)

    window.addEventListener("phlex-kit:toast", this._onWindowToast)
    window.addEventListener("phlex-kit:toast:dismiss-all", this._onWindowDismissAll)
    window.addEventListener("phlex-kit:toast:dismiss", this._onWindowDismissId)
    document.addEventListener("turbo:before-render", this._onBeforeRender)
    this._listEl.addEventListener("pointerenter", this._onPointerEnter)
    this._listEl.addEventListener("pointerleave", this._onPointerLeave)
    document.addEventListener("keydown", this._onKey)

    // Settle any server-rendered toasts (their targetConnected ran pre-connect,
    // before _listEl existed, so their reflow was a no-op).
    this._reflow()
  }

  disconnect() {
    window.removeEventListener("phlex-kit:toast", this._onWindowToast)
    window.removeEventListener("phlex-kit:toast:dismiss-all", this._onWindowDismissAll)
    window.removeEventListener("phlex-kit:toast:dismiss", this._onWindowDismissId)
    document.removeEventListener("turbo:before-render", this._onBeforeRender)
    this._listEl?.removeEventListener("pointerenter", this._onPointerEnter)
    this._listEl?.removeEventListener("pointerleave", this._onPointerLeave)
    document.removeEventListener("keydown", this._onKey)
    // Drop the global API if it still closes over this controller — after
    // region teardown it would touch a stale _listEl. A replacement region
    // re-registers its own on connect.
    if (window.PhlexKit?.toast === this._api) delete window.PhlexKit.toast
  }

  toastTargetConnected(el) {
    if (typeof ResizeObserver !== "undefined") {
      const ro = new ResizeObserver(() => {
        this._heights.set(el, el.offsetHeight)
        this._reflow()
      })
      ro.observe(el)
      this._resizeObservers.set(el, ro)
    }
    this._heights.set(el, el.offsetHeight || 64)
    this._reflow()
  }

  toastTargetDisconnected(el) {
    this._resizeObservers.get(el)?.disconnect()
    this._resizeObservers.delete(el)
    this._heights.delete(el)
    this._reflow()
  }

  _spawn(detail) {
    const variant = VARIANTS.includes(detail.variant) ? detail.variant : "default"
    const tpl = this._skeletonFor(variant)
    if (!tpl) return null
    if (detail.position) {
      this.element.setAttribute("data-position", detail.position)
      this.positionValue = detail.position
    }
    const node = tpl.content.firstElementChild.cloneNode(true)

    node.id = detail.id || `toast-${this._uuid()}`
    if (detail.duration != null) {
      const dur = detail.duration === Infinity ? 0 : detail.duration
      node.setAttribute("data-phlex-kit--toast-duration-value", String(dur))
    }
    if (detail.dismissible === false) {
      node.setAttribute("data-phlex-kit--toast-dismissible-value", "false")
    }
    if (detail.className) node.className += ` ${detail.className}`

    const titleEl = node.querySelector('[data-slot="title"]')
    if (titleEl) titleEl.textContent = detail.title || detail.message || ""
    const descEl = node.querySelector('[data-slot="description"]')
    if (descEl) {
      if (detail.description) descEl.textContent = detail.description
      else descEl.remove()
    }

    if (detail.action && detail.action.label && this.hasActionTplTarget) {
      const btn = this._cloneSlot(this.actionTplTarget)
      btn.textContent = detail.action.label
      btn.addEventListener("click", (ev) => {
        try { detail.action.onClick?.(ev) } finally {
          node.dispatchEvent(new CustomEvent("phlex-kit:toast:force-dismiss", { bubbles: true }))
        }
      })
      node.appendChild(btn)
    }

    if (detail.cancel && detail.cancel.label && this.hasCancelTplTarget) {
      const btn = this._cloneSlot(this.cancelTplTarget)
      btn.textContent = detail.cancel.label
      node.appendChild(btn)
    }

    // Don't append a second close button when the skeleton already baked one
    // in (region rendered with close_button: true) — spawning with
    // closeButton: true would otherwise stack two ×'s.
    if (detail.closeButton && this.hasCloseTplTarget && !node.querySelector('[data-slot="close"]')) {
      const x = this._cloneSlot(this.closeTplTarget)
      node.classList.add("pk-toast-with-close")
      node.appendChild(x)
    }

    this._listEl.appendChild(node)
    return node.id
  }

  // Move server-rendered flash toasts from the incoming (about-to-be-discarded)
  // page's matching region into this permanent list, so a Turbo Drive visit
  // doesn't silently drop them. Runs on turbo:before-render, before Turbo
  // transplants this permanent element into the new body (children ride along).
  _adoptIncomingToasts(e) {
    const newBody = e.detail?.newBody
    if (!newBody || !this._listEl?.id) return
    const incomingList = newBody.querySelector(`#${CSS.escape(this._listEl.id)}`)
    if (!incomingList) return
    incomingList.querySelectorAll(":scope > [data-phlex-kit--toaster-target='toast']").forEach((el) => {
      // Skip a flash id already showing here, so a re-render doesn't dupe it.
      if (el.id && this._listEl.querySelector(`#${CSS.escape(el.id)}`)) return
      this._listEl.appendChild(el.cloneNode(true))
    })
  }

  // True when this region should act on a toast event carrying `region`
  // (the list's base id or the wrapper's "<id>-region" both match). Without
  // an explicit region, only the page's first region in DOM order handles
  // the broadcast — single-region pages are unaffected.
  _handlesRegion(region) {
    if (region) return region === this.element.id || region === this._listEl?.id
    return this.element === document.querySelector("[data-controller~='phlex-kit--toaster']")
  }

  _dismissById(id) {
    if (!id) {
      this.toastTargets.forEach((el) =>
        el.dispatchEvent(new CustomEvent("phlex-kit:toast:force-dismiss", { bubbles: true }))
      )
      return
    }
    if (!this._listEl) return
    const el = this._listEl.querySelector(`#${CSS.escape(id)}`)
    if (el) el.dispatchEvent(new CustomEvent("phlex-kit:toast:force-dismiss", { bubbles: true }))
  }

  _skeletonFor(variant) {
    return this.skeletonTargets.find((t) => t.dataset.variant === variant)
  }

  _cloneSlot(tpl) {
    return tpl.content.firstElementChild.cloneNode(true)
  }

  _setPaused(value) {
    if (this._paused === value) return
    this._paused = value
    // Mirror the pause state onto the DOM so toasts spawned while the stack
    // is already hovered can arm paused (the pause event predates them).
    this._listEl?.toggleAttribute("data-pk-toasts-paused", value)
    // Region-scoped, not document-global: on multi-region pages one region's
    // hover must not pause (or worse, RESUME under the pointer) another's
    // toasts. Toasts listen on their own list element.
    this._listEl.dispatchEvent(new CustomEvent(value ? "phlex-kit:toast:pause" : "phlex-kit:toast:resume"))
  }

  _setExpanded(value) {
    if (this._expanded === value) return
    this._expanded = value
    this._reflow()
  }

  _reflow() {
    if (!this._listEl) return
    const isBottom = this.positionValue.startsWith("bottom")
    const items = this.toastTargets
    // Newest toast fronts the stack at BOTH edges (index 0 = front); only
    // the offset direction flips with the position. Using DOM order at
    // top-* put the oldest toast in front and stacked new ones behind it.
    const order = items.slice().reverse()
    const heights = order.map(el => this._heights.get(el) || el.offsetHeight || 64)
    const gap = this.gapValue
    const peekOffset = 16
    const peekScaleStep = 0.05
    const peekOpacityStep = 0.2

    const expandedHeight = heights.reduce((a, b) => a + b, 0) + gap * Math.max(0, heights.length - 1)
    const collapsedHeight = (heights[0] || 0) + Math.min(2, Math.max(0, heights.length - 1)) * peekOffset
    this._listEl.style.minHeight = `${this._expanded ? expandedHeight : collapsedHeight}px`

    let acc = 0
    order.forEach((el, i) => {
      const visible = i < this.maxValue
      let yOffset, scale, opacity

      if (this._expanded) {
        yOffset = acc + i * gap
        scale = 1
        opacity = visible ? 1 : 0
      } else {
        yOffset = i * peekOffset
        scale = Math.max(0.85, 1 - i * peekScaleStep)
        opacity = visible ? Math.max(0, 1 - i * peekOpacityStep) : 0
      }

      const sign = isBottom ? -1 : 1
      const ty = sign * yOffset

      el.style.setProperty("--opacity", String(opacity))
      el.style.setProperty("--scale", String(scale))
      el.style.setProperty("--y-offset", `${ty}px`)
      el.style.transformOrigin = isBottom ? "center bottom" : "center top"
      el.style.top = isBottom ? "auto" : "0"
      el.style.bottom = isBottom ? "0" : "auto"
      // Compose the toast controller's swipe offset (custom props it sets
      // during pointer-drag) into the stacking transform — the swipe must
      // never overwrite this transform or non-front toasts snap out of place.
      el.style.transform = `translate3d(var(--pk-toast-swipe-x, 0px), calc(${ty}px + var(--pk-toast-swipe-y, 0px)), 0) scale(${scale})`
      el.style.zIndex = String(1000 - i)
      el.style.pointerEvents = visible ? "auto" : "none"
      el.tabIndex = visible ? 0 : -1

      acc += heights[i] || 0
    })

    this._enforceMax(items)
  }

  _enforceMax(items) {
    if (items.length <= this.maxValue) return
    const dropping = items.length - this.maxValue
    // Evict the OLDEST toasts (DOM order = append order) regardless of edge;
    // slicing from the tail at top-* dropped the newest ones instead.
    const candidates = items.slice(0, dropping)
    candidates.forEach(el => {
      if (el.dataset.state !== "closing") {
        el.dispatchEvent(new CustomEvent("phlex-kit:toast:force-dismiss", { bubbles: true }))
      }
    })
  }

  _onKey(e) {
    const parts = (this.hotkeyValue || "alt+t").split("+")
    const key = parts.pop()
    const wantAlt = parts.includes("alt")
    const wantCtrl = parts.includes("ctrl")
    const wantMeta = parts.includes("meta")
    const wantShift = parts.includes("shift")
    // Match e.code as well as e.key: with Option held, macOS reports the
    // COMPOSED character (Option+T → "†"), so alt+ hotkeys never match on
    // e.key alone (Sonner matches event.code for the same reason).
    const code = (e.code || "").toLowerCase()
    const keyMatches = e.key.toLowerCase() === key.toLowerCase()
      || code === `key${key.toLowerCase()}`
      || code === `digit${key.toLowerCase()}`
    if (!keyMatches) return
    if (wantAlt !== e.altKey) return
    if (wantCtrl !== e.ctrlKey) return
    if (wantMeta !== e.metaKey) return
    if (wantShift !== e.shiftKey) return
    e.preventDefault()
    // Newest toast is the LAST child (append order) and fronts the stack —
    // the first child is the oldest, faded, possibly pointer-events:none one.
    const newest = this._listEl.lastElementChild
    newest?.focus()
  }

  _registerGlobalApi() {
    const fire = (variant, message, opts = {}) =>
      window.dispatchEvent(new CustomEvent("phlex-kit:toast", {
        detail: { ...opts, variant, message: opts.title || message }
      }))

    const api = (message, opts) => fire("default", message, opts)
    api.success = (m, o) => fire("success", m, o)
    api.error = (m, o) => fire("error", m, o)
    api.warning = (m, o) => fire("warning", m, o)
    api.info = (m, o) => fire("info", m, o)
    api.loading = (m, o = {}) => fire("loading", m, { ...o, duration: o.duration ?? 0 })
    api.dismiss = (id) => {
      // Both broadcasts: whichever region owns the id dismisses it — the
      // api may be registered by a different region than the owner.
      if (id) window.dispatchEvent(new CustomEvent("phlex-kit:toast:dismiss", { detail: { id } }))
      else window.dispatchEvent(new CustomEvent("phlex-kit:toast:dismiss-all"))
    }
    api.promise = (p, msgs = {}) => {
      const id = `toast-${this._uuid()}`
      fire("loading", typeof msgs.loading === "function" ? msgs.loading() : (msgs.loading || "Loading..."), { id, duration: 0, region: msgs.region })
      Promise.resolve(p).then(
        (val) => this._mutate(id, "success", typeof msgs.success === "function" ? msgs.success(val) : msgs.success),
        (err) => this._mutate(id, "error", typeof msgs.error === "function" ? msgs.error(err) : msgs.error)
      )
      return id
    }

    window.PhlexKit = window.PhlexKit || {}
    this._api = api
    window.PhlexKit.toast = api
  }

  _mutate(id, variant, text) {
    // Document-scoped: promise()'s loading toast spawns in whichever region
    // the broadcast routed it to, which need not be the region that
    // registered the api this closure belongs to.
    const el = document.getElementById(id)
    if (!el || !el.closest(".pk-toast-list")) return
    el.dataset.variant = variant
    el.setAttribute("role", variant === "error" ? "alert" : "status")
    this._swapIcon(el, variant)
    const t = el.querySelector('[data-slot="title"]')
    if (t && text) t.textContent = text
    const dur = String(this.durationValue)
    el.setAttribute("data-phlex-kit--toast-duration-value", dur)
    el.dispatchEvent(new CustomEvent("phlex-kit:toast:restart", { bubbles: true }))
  }

  _swapIcon(el, variant) {
    const iconHost = el.querySelector('[data-slot="icon"]')
    if (!iconHost) return
    const tpl = this._skeletonFor(variant)
    if (!tpl) return
    const sourceIcon = tpl.content.firstElementChild?.querySelector('[data-slot="icon"]')
    iconHost.innerHTML = sourceIcon ? sourceIcon.innerHTML : ""
  }

  _uuid() {
    if (typeof crypto !== "undefined" && crypto.randomUUID) return crypto.randomUUID()
    return Math.random().toString(36).slice(2) + Date.now().toString(36)
  }
}
