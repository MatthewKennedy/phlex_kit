import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--context-menu". Opens at the cursor
// on contextmenu (at the trigger's rect for the keyboard Menu key / Shift+F10,
// which fire with clientX/Y of 0) and focuses the first item; ArrowDown/
// ArrowUp/Home/End rove over the items (skipping [data-disabled]); closes on
// outside click or Escape, returning focus to the trigger. The panel is a
// native [popover=manual] in the top layer (context_menu.css); it is placed
// in viewport coordinates after showPopover() — a hidden popover has no
// size — and clamped so it never overflows the viewport (no floating-ui).

// One-shot capture listener swallowing the click an outside mousedown is
// about to produce (see onDocMousedown; same helper in dropdown/menubar —
// duplicated per controller by design). {once} self-removes; the DOM
// dedupes re-arming with the same fn. If the gesture's click never fires
// (e.g. suppressed after a selection drag) the armed swallow eats the next
// one — rare enough to accept.
const swallowClick = (ev) => ev.preventDefault()
function armSwallowClick() {
  window.addEventListener("click", swallowClick, { once: true, capture: true })
}

export default class extends Controller {
  static targets = ["content", "trigger", "menuItem"]

  connect() {
    this.onDoc = (e) => {
      if (this.contentTarget.contains(e.target)) return
      // The opening right-click bubbles to document AFTER open() adds this
      // listener — a contextmenu inside our own element must not close what
      // it just opened (it repositions instead). A contextmenu anywhere
      // else closes us, which also covers opening a second kit context
      // menu: its trigger's contextmenu is "outside" for this instance.
      if (e.type === "contextmenu" && this.element.contains(e.target)) return
      this.close()
    }
    // Kit-wide dismiss contract (Radix modal-menu parity): a plain click
    // outside only dismisses — swallowed, like dropdown/menubar/select.
    // Armed at MOUSEDOWN: the gesture's focusout close() removes onDoc
    // before the click even fires. Right-button mousedowns are ignored so a
    // contextmenu elsewhere stays click-through (that's how a second kit —
    // or the native — context menu opens in the same gesture).
    this.onDocMousedown = (e) => {
      if (this.contentTarget.contains(e.target)) return
      if (e.button !== 0) return
      armSwallowClick()
    }
    this.onKey = (e) => this.keydown(e)
    // Turbo snapshots BEFORE disconnect — close now or the snapshot keeps a
    // stale data-state="open" (the panel itself can't resurrect, but host
    // CSS keyed on the state hook would misfire after a restore).
    this.onBeforeCache = () => {
      if (this.contentTarget.matches(":popover-open")) this.close()
    }
    document.addEventListener("turbo:before-cache", this.onBeforeCache)
    // Outstanding syncSub rAF handles — cancelled on disconnect (menubar's
    // pattern).
    this.subFrames = new Set()
    // A Turbo snapshot (or a detach/reattach that mimics one) serializes
    // aria-expanded="true" on sub triggers even though no submenu can be
    // open at connect time — sweep every stale marker back to false
    // (menubar's pattern).
    this.element.querySelectorAll("[aria-expanded='true']").forEach((el) => el.setAttribute("aria-expanded", "false"))
    // Same shape for checkbox/radio rows: their `checked` DOM property
    // survives a reconnect but a hand-edited/replayed aria-checked can drift
    // from it — resync every row from its live input.
    this.element.querySelectorAll('input[type="checkbox"], input[type="radio"]').forEach((i) => {
      i.closest('[role^="menuitem"]')?.setAttribute("aria-checked", i.checked)
    })
  }

  disconnect() {
    document.removeEventListener("mousedown", this.onDocMousedown)
    document.removeEventListener("click", this.onDoc)
    document.removeEventListener("contextmenu", this.onDoc)
    document.removeEventListener("keydown", this.onKey)
    document.removeEventListener("turbo:before-cache", this.onBeforeCache)
    this.subFrames.forEach((id) => cancelAnimationFrame(id))
    this.subFrames.clear()
  }

  // Mirrors the CSS-driven submenu state (:hover / :focus-within) onto the
  // sub trigger's aria-expanded — same wiring as dropdown_menu/menubar.
  syncSub(e) {
    const sub = e.currentTarget
    const id = requestAnimationFrame(() => {
      this.subFrames.delete(id)
      sub.querySelector(":scope > [aria-haspopup]")
        ?.setAttribute("aria-expanded", sub.matches(":hover, :focus-within"))
    })
    this.subFrames.add(id)
  }

  // Tabbing (or otherwise moving real focus) out of the menu closes it —
  // menubar's onFocusout pattern (menubar_controller.js). relatedTarget is
  // null when the window itself blurs — leave the menu alone then. The
  // trigger + content are both DOM children of this.element even though the
  // content is a top-layer popover, so one containment check covers both.
  onFocusout(e) {
    if (!this.contentTarget.matches(":popover-open")) return
    const to = e.relatedTarget
    if (!to || this.element.contains(to)) return
    this.close()
  }

  open(e) {
    e.preventDefault()
    let x = e.clientX
    let y = e.clientY
    if (x === 0 && y === 0) {
      const t = this.anchor().getBoundingClientRect()
      x = t.left
      y = t.bottom
    }
    const c = this.contentTarget
    if (!c.matches(":popover-open")) c.showPopover()
    x = Math.max(4, Math.min(x, window.innerWidth - c.offsetWidth - 4))
    y = Math.max(4, Math.min(y, window.innerHeight - c.offsetHeight - 4))
    c.style.left = `${x}px`
    c.style.top = `${y}px`
    c.dataset.state = "open"
    document.addEventListener("mousedown", this.onDocMousedown)
    document.addEventListener("click", this.onDoc)
    document.addEventListener("contextmenu", this.onDoc)
    document.addEventListener("keydown", this.onKey)
    this.items()[0]?.focus()
  }

  close(opts = {}) {
    // Menu rows default to href="#"; without this an Enter/click on a
    // non-link row scrolls to top and appends # to the URL. (`opts` is the
    // click event when close runs as the item's data-action; Enter/Space
    // arrive here too, via keydown()'s synthesized click.)
    if (opts?.target?.closest?.('a[href="#"]')) opts.preventDefault()
    if (this.contentTarget.matches(":popover-open")) this.contentTarget.hidePopover()
    this.contentTarget.dataset.state = "closed"
    document.removeEventListener("mousedown", this.onDocMousedown)
    document.removeEventListener("click", this.onDoc)
    document.removeEventListener("contextmenu", this.onDoc)
    document.removeEventListener("keydown", this.onKey)
    if (opts.refocus === true) this.anchor().focus()
  }

  keydown(e) {
    // This listener stays attached document-wide while the menu is open (see
    // open()/close()) so it keeps receiving events even once real focus has
    // left the menu — scope the roving-nav keys to when focus is actually
    // within the widget (this.element, not just contentTarget, so a focused
    // trigger still counts). Escape stays global while the menu is open (APG).
    if (e.key !== "Escape" && !this.element.contains(document.activeElement)) return

    const items = this.items()
    const index = items.indexOf(document.activeElement)
    switch (e.key) {
      case "Escape":
        e.preventDefault()
        this.close({ refocus: true })
        break
      case "ArrowDown":
        e.preventDefault()
        items[(index + 1) % items.length]?.focus()
        break
      case "ArrowUp":
        e.preventDefault()
        items[index < 0 ? items.length - 1 : (index - 1 + items.length) % items.length]?.focus()
        break
      case "Home":
        e.preventDefault()
        items[0]?.focus()
        break
      case "End":
        e.preventDefault()
        items[items.length - 1]?.focus()
        break
      case "Enter":
      case " ":
        // Explicit click so label rows (checkbox/radio) activate — labels
        // have no native keyboard activation (and this gives links Space).
        if (index >= 0) {
          e.preventDefault()
          items[index].click()
        }
        break
      case "ArrowRight":
      case "ArrowLeft": {
        // Submenus open inline-end — visually LEFT in RTL — so the enter key
        // follows visual direction: ArrowLeft enters / ArrowRight exits in RTL
        // (and the reverse in LTR). Runtime dir check is reliable after a flip.
        const rtl = getComputedStyle(this.element).direction === "rtl"
        const enterKey = rtl ? "ArrowLeft" : "ArrowRight"
        if (e.key === enterKey) {
          // On a sub trigger, enter the submenu (focus reveals it via
          // :focus-within, making its rows visible to the roving nav).
          if (document.activeElement?.matches(".pk-context-menu-sub-trigger")) {
            e.preventDefault()
            this.enterSub(document.activeElement)
          }
        } else {
          // Inside a submenu, step back to its trigger (closes it on focus-out).
          const sub = document.activeElement?.closest(".pk-context-menu-sub-content")
          if (sub) {
            e.preventDefault()
            sub.closest(".pk-context-menu-sub")?.querySelector(".pk-context-menu-sub-trigger")?.focus()
          }
        }
        break
      }
    }
  }

  enterSub(trigger) {
    trigger.focus()
    const panel = trigger.closest(".pk-context-menu-sub")?.querySelector(".pk-context-menu-sub-content")
    if (!panel) return
    const first = [...panel.querySelectorAll("[role^=\"menuitem\"]")]
      .find((el) => !el.closest("[data-disabled]") && el.getClientRects().length > 0)
    first?.focus()
  }

  // Mirrors a checkbox/radio row's native input state onto the row's
  // aria-checked (radios also reset their group's siblings).
  syncChecked(e) {
    const input = e.target
    const group = input.name
      ? this.element.querySelectorAll(`input[name="${CSS.escape(input.name)}"]`)
      : [input]
    group.forEach((i) => i.closest("[role^=\"menuitem\"]")?.setAttribute("aria-checked", i.checked))
  }

  anchor() {
    return this.hasTriggerTarget ? this.triggerTarget : this.element
  }

  items() {
    // getClientRects also skips rows inside a CLOSED sub panel (its
    // display:none comes from the hover/focus-within CSS, not .pk-hidden) —
    // focus() on those silently fails and the roving nav jams there.
    return this.menuItemTargets.filter(
      (el) => !el.closest("[data-disabled]") && el.getClientRects().length > 0
    )
  }
}
