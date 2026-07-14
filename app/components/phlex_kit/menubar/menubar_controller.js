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
export default class extends Controller {
  static targets = ["menu"]

  // Which menu is open derives from the live :popover-open state, never a
  // stored field — a stale field would make toggle() call showPopover() on
  // an already-open panel (InvalidStateError) or strand an open one.
  get openMenu() {
    return this.menuTargets.find((menu) => this.panel(menu)?.matches(":popover-open")) ?? null
  }

  disconnect() {
    clearTimeout(this.graceTimer)
  }

  toggle(e) {
    const menu = e.currentTarget.closest("[data-phlex-kit--menubar-target=\"menu\"]")
    this.openMenu === menu ? this.close() : this.show(menu, true)
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
      this.panel(menu)?.showPopover()
      menu.querySelector("[aria-expanded]")?.setAttribute("aria-expanded", "true")
    }
    if (focus) this.items(menu)[0]?.focus()
  }

  close(opts = {}) {
    clearTimeout(this.graceTimer)
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
        // Closed bar: left/right move focus between the triggers (APG).
        e.preventDefault()
        const menus = this.menuTargets
        const next = menus[(menus.indexOf(menu) + (e.key === "ArrowRight" ? 1 : -1) + menus.length) % menus.length]
        next?.querySelector("[aria-expanded], a, button, [tabindex]")?.focus()
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
        e.preventDefault()
        // On a sub trigger, enter the submenu (focus reveals it via
        // :focus-within) instead of jumping to the next top-level menu.
        if (document.activeElement?.matches(".pk-menubar-sub-trigger")) {
          this.enterSub(document.activeElement)
        } else {
          this.shift(1)
        }
        break
      case "ArrowLeft": {
        e.preventDefault()
        // Inside a submenu, step back to its trigger instead of switching menus.
        const sub = document.activeElement?.closest(".pk-menubar-sub-content")
        if (sub) {
          sub.closest(".pk-menubar-sub")?.querySelector(".pk-menubar-sub-trigger")?.focus()
        } else {
          this.shift(-1)
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

  shift(dir) {
    const menus = this.menuTargets
    const index = menus.indexOf(this.openMenu)
    this.show(menus[(index + dir + menus.length) % menus.length], true)
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
    return [...panel.querySelectorAll("[role^=\"menuitem\"]")]
      .filter((el) => !el.closest("[data-disabled]") && el.getClientRects().length > 0)
  }
}
