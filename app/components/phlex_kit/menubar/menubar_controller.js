import { Controller } from "@hotwired/stimulus"

// PhlexKit's stand-in for Radix behind shadcn's Menubar and NavigationMenu.
// Panels are native [popover=manual] elements (manual: this controller owns
// open/close), anchor-positioned per menu with viewport-edge flipping by
// menubar.css / navigation_menu.css.
// Click (or hover, for nav menus) opens a menu's panel; while one is open,
// hovering a sibling trigger switches to it; Escape/outside/item click closes.
// Keyboard (menubar mode): ArrowDown on a trigger opens its menu focusing the
// first item; ArrowDown/ArrowUp/Home/End rove over the open menu's items
// (skipping [data-disabled]); ArrowLeft/ArrowRight jump to the sibling menus;
// Escape closes and returns focus to the trigger.
// Connects to data-controller="phlex-kit--menubar"
let uid = 0

export default class extends Controller {
  static targets = ["menu"]

  // Which menu is open derives from the live :popover-open state, never a
  // stored field — a stale field would make toggle() call showPopover() on
  // an already-open panel (InvalidStateError) or strand an open one.
  get openMenu() {
    return this.menuTargets.find((menu) => this.panel(menu)?.matches(":popover-open")) ?? null
  }

  initialize() {
    // menuTargetConnected fires BEFORE connect() — state it reads must be
    // set here. Roving tabindex applies only in menubar mode: a nav's
    // triggers and links stay natural tab stops.
    this.roving = this.element.dataset.hoverOpen === undefined
    // Outstanding syncSub rAF handles — cancelled on disconnect so a queued
    // frame never touches a torn-down menubar.
    this.subFrames = new Set()
  }

  // Pair each trigger with its panel for AT (aria-controls), and fold the
  // trigger into the roving tabindex (first trigger 0, rest -1).
  menuTargetConnected(menu) {
    const trigger = this.trigger(menu)
    const panel = this.panel(menu)
    if (trigger && panel) {
      if (!panel.id) panel.id = `pk-menu-panel-${++uid}`
      trigger.setAttribute("aria-controls", panel.id)
    }
    // A Turbo snapshot serializes aria-expanded="true" even though the
    // panel's :popover-open does not survive the restore — no panel can be
    // open at connect time, so stamp every expanded marker back to false
    // (only on elements that already carry it: plain nav links must not
    // grow an aria-expanded). Covers the trigger and CSS-revealed subs.
    menu.querySelectorAll("[aria-expanded='true']").forEach((el) => el.setAttribute("aria-expanded", "false"))
    // Same shape for checkbox/radio rows: their `checked` DOM property
    // survives a reconnect but a hand-edited/replayed aria-checked can drift
    // from it — resync every row from its live input.
    menu.querySelectorAll('input[type="checkbox"], input[type="radio"]').forEach((i) => {
      i.closest('[role^="menuitem"]')?.setAttribute("aria-checked", i.checked)
    })
    if (this.roving) this.applyRoving()
  }

  menuTargetDisconnected() {
    if (this.roving) this.applyRoving()
  }

  disconnect() {
    clearTimeout(this.graceTimer)
    this.subFrames.forEach((id) => cancelAnimationFrame(id))
    this.subFrames.clear()
  }

  toggle(e) {
    const menu = e.currentTarget.closest("[data-phlex-kit--menubar-target=\"menu\"]")
    // detail 0 = keyboard-activated click (Enter/Space): only then does the
    // first item get force-focused — a mouse open leaves focus on the trigger.
    this.openMenu === menu ? this.close() : this.show(menu, e.detail === 0)
  }

  // Hover: switches between menus while one is open (menubar), or opens
  // directly when the bar declares data-hover-open (navigation menu).
  switch(e) {
    clearTimeout(this.graceTimer)
    const menu = e.currentTarget.closest("[data-phlex-kit--menubar-target=\"menu\"]")
    if (this.element.dataset.hoverOpen !== undefined) {
      if (!menu || !this.panel(menu)) return this.closeSoon() // link, no panel
      return this.show(menu)
    }
    if (!menu) return this.close()
    if (this.openMenu && this.openMenu !== menu) this.show(menu)
  }

  // Hover closes go through a short grace period so a diagonal pointer path
  // that clips a sibling link (or briefly exits the nav) on its way to the
  // panel doesn't slam it shut; reaching the panel or a trigger cancels.
  closeSoon() {
    clearTimeout(this.graceTimer)
    this.graceTimer = setTimeout(() => this.close(), 150)
  }

  cancelClose() {
    clearTimeout(this.graceTimer)
  }

  show(menu, focus = false) {
    if (this.openMenu !== menu) {
      this.close()
      if (this.panel(menu)) {
        this.panel(menu).showPopover()
        menu.querySelector("[aria-expanded]")?.setAttribute("aria-expanded", "true")
      }
    }
    if (this.roving) this.applyRoving(this.trigger(menu))
    // No panel items (e.g. a panel-less nav link item reached via arrows):
    // land on the trigger itself instead of stranding focus.
    if (focus) (this.items(menu)[0] ?? this.trigger(menu))?.focus()
  }

  // Also wired directly as the click handler on plain nav links (see
  // navigation_menu_link.rb) — `opts` is then the click Event rather than an
  // options hash. Guard the default href="#" (dropdown_menu_controller.js's
  // close() does the same) so a link without a real destination doesn't
  // scroll-to-top/append a hash; a link WITH a real href is left to navigate
  // normally, closing whatever panel is open on the way out.
  close(opts = {}) {
    clearTimeout(this.graceTimer)
    if (opts?.target?.closest?.('a[href="#"]')) opts.preventDefault?.()
    const menu = this.openMenu
    if (!menu) return
    const panel = this.panel(menu)
    if (panel?.matches(":popover-open")) panel.hidePopover()
    const trigger = menu.querySelector("[aria-expanded]")
    trigger?.setAttribute("aria-expanded", "false")
    if (opts.refocus === true) trigger?.focus()
  }

  onClickOutside(e) {
    if (this.element.contains(e.target)) return
    this.close()
  }

  // Tabbing out of the bar: close the open [popover=manual] panel once focus
  // has left both the bar AND the panel (panels are top-layer popovers, but
  // remain DOM children — check both anyway). Focus moving INTO the panel
  // during normal navigation must not close it. relatedTarget is null when
  // the window itself blurs — leave the menu alone then.
  onFocusout(e) {
    const to = e.relatedTarget
    if (!to || this.element.contains(to)) return
    const menu = this.openMenu
    if (!menu) return
    if (this.panel(menu)?.contains(to)) return
    this.close()
  }

  // Single keydown listener on the bar (wired via data-action, so no manual
  // cleanup): roving focus while a menu is open, ArrowDown-opens while closed.
  onKeydown(e) {
    if (!this.openMenu) {
      const menu = e.target.closest("[data-phlex-kit--menubar-target=\"menu\"]")
      if (!menu) return
      if (e.key === "ArrowDown") {
        e.preventDefault()
        this.show(menu, true)
      } else if (e.key === "ArrowRight" || e.key === "ArrowLeft") {
        // Closed bar: left/right move focus between the triggers (APG). In RTL
        // the bar mirrors, so the physical LEFT arrow moves to the next
        // trigger. Runtime dir check is reliable after a dynamic flip.
        e.preventDefault()
        const rtl = getComputedStyle(this.element).direction === "rtl"
        const step = (e.key === "ArrowRight" ? 1 : -1) * (rtl ? -1 : 1)
        const menus = this.menuTargets
        const next = menus[(menus.indexOf(menu) + step + menus.length) % menus.length]
        const target = next ? this.trigger(next) : null
        target?.focus()
        if (this.roving && target) this.applyRoving(target)
      }
      return
    }
    const items = this.items(this.openMenu)
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
        e.preventDefault()
        // Both the submenu (opens inline-end = visually LEFT in RTL) and the
        // top-level menu traversal follow visual direction: the "enter/next"
        // key is ArrowLeft in RTL, ArrowRight in LTR. Runtime dir check is
        // reliable after a dynamic flip.
        const rtl = getComputedStyle(this.element).direction === "rtl"
        const enterKey = rtl ? "ArrowLeft" : "ArrowRight"
        if (e.key === enterKey) {
          // On a sub trigger, enter the submenu (focus reveals it via
          // :focus-within) instead of jumping to the next top-level menu.
          if (document.activeElement?.matches(".pk-menubar-sub-trigger")) {
            this.enterSub(document.activeElement)
          } else {
            this.shift(1)
          }
        } else {
          // Inside a submenu, step back to its trigger instead of switching menus.
          const sub = document.activeElement?.closest(".pk-menubar-sub-content")
          if (sub) {
            sub.closest(".pk-menubar-sub")?.querySelector(".pk-menubar-sub-trigger")?.focus()
          } else {
            this.shift(-1)
          }
        }
        break
      }
    }
  }

  // Focus the first row of a sub trigger's panel. The panel opens on
  // :focus-within, so focus the trigger first, then hop into the revealed
  // panel's first visible item.
  enterSub(trigger) {
    trigger.focus()
    const panel = trigger.closest(".pk-menubar-sub")?.querySelector(".pk-menubar-sub-content")
    if (!panel) return
    const first = [...panel.querySelectorAll("[role^=\"menuitem\"]")]
      .find((el) => !el.closest("[data-disabled]") && el.getClientRects().length > 0)
    first?.focus()
  }

  // Mirrors a checkbox/radio item's native input state onto the item's
  // aria-checked (radios also reset their group's siblings).
  syncChecked(e) {
    const input = e.target
    const group = input.name
      ? this.element.querySelectorAll(`input[name="${CSS.escape(input.name)}"]`)
      : [input]
    group.forEach((i) => i.closest("[role^=\"menuitem\"]")?.setAttribute("aria-checked", i.checked))
  }

  // Mirrors the CSS-driven submenu state (:hover / :focus-within) onto the
  // sub trigger's aria-expanded. rAF: on mouseleave/focusout the pseudo-class
  // state isn't settled until the event finishes dispatching.
  syncSub(e) {
    const sub = e.currentTarget
    const id = requestAnimationFrame(() => {
      this.subFrames.delete(id)
      sub.querySelector(":scope > [aria-haspopup]")
        ?.setAttribute("aria-expanded", sub.matches(":hover, :focus-within"))
    })
    this.subFrames.add(id)
  }

  shift(dir) {
    const menus = this.menuTargets
    const index = menus.indexOf(this.openMenu)
    this.show(menus[(index + dir + menus.length) % menus.length], true)
  }

  // The bar's single tab stop (APG menubar): `current` keeps tabindex 0,
  // every other trigger gets -1.
  applyRoving(current = null) {
    const triggers = this.menuTargets.map((menu) => this.trigger(menu)).filter(Boolean)
    if (triggers.length === 0) return
    if (!current || !triggers.includes(current)) {
      current = triggers.find((t) => t.getAttribute("tabindex") === "0") ?? triggers[0]
    }
    triggers.forEach((t) => t.setAttribute("tabindex", t === current ? "0" : "-1"))
  }

  trigger(menu) {
    return menu?.querySelector("[aria-expanded], a, button, [tabindex]")
  }

  panel(menu) {
    return menu.querySelector("[role=\"menu\"], .pk-menubar-content, .pk-navigation-menu-content")
  }

  items(menu) {
    const panel = this.panel(menu)
    if (!panel) return []
    // getClientRects also skips rows inside a CLOSED sub panel (its
    // display:none comes from the hover/focus-within CSS, not .pk-hidden) —
    // focus() on those silently fails and the roving nav jams there.
    // Nav panels hold plain links (no menu roles, matching Radix/shadcn) —
    // fall back to them so arrow keys navigate there too.
    const rows = [...panel.querySelectorAll("[role^=\"menuitem\"]")]
    const list = rows.length ? rows : [...panel.querySelectorAll("a[href], button")]
    return list.filter((el) => !el.closest("[data-disabled]") && el.getClientRects().length > 0)
  }
}
