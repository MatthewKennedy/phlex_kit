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

  initialize() {
    this.openMenu = null
  }

  toggle(e) {
    const menu = e.currentTarget.closest("[data-phlex-kit--menubar-target=\"menu\"]")
    this.openMenu === menu ? this.close() : this.show(menu, true)
  }

  // Hover: switches between menus while one is open (menubar), or opens
  // directly when the bar declares data-hover-open (navigation menu).
  switch(e) {
    const menu = e.currentTarget.closest("[data-phlex-kit--menubar-target=\"menu\"]")
    if (!menu) return this.close() // a link outside any menu item — just close
    if (this.element.dataset.hoverOpen !== undefined) return this.show(menu)
    if (this.openMenu && this.openMenu !== menu) this.show(menu)
  }

  show(menu, focus = false) {
    if (this.openMenu !== menu) {
      this.close()
      this.panel(menu)?.showPopover()
      menu.querySelector("[aria-expanded]")?.setAttribute("aria-expanded", "true")
      this.openMenu = menu
    }
    if (focus) this.items(menu)[0]?.focus()
  }

  close(opts = {}) {
    const menu = this.openMenu
    if (!menu) return
    const panel = this.panel(menu)
    if (panel?.matches(":popover-open")) panel.hidePopover()
    const trigger = menu.querySelector("[aria-expanded]")
    trigger?.setAttribute("aria-expanded", "false")
    this.openMenu = null
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
      if (e.key !== "ArrowDown") return
      const menu = e.target.closest("[data-phlex-kit--menubar-target=\"menu\"]")
      if (!menu) return
      e.preventDefault()
      this.show(menu, true)
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
      case "ArrowRight":
        e.preventDefault()
        this.shift(1)
        break
      case "ArrowLeft":
        e.preventDefault()
        this.shift(-1)
        break
    }
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
    return [...panel.querySelectorAll("[role^=\"menuitem\"]")]
      .filter((el) => !el.closest("[data-disabled]") && !el.closest(".pk-hidden"))
  }
}
