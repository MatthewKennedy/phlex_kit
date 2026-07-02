import { Controller } from "@hotwired/stimulus"

// PhlexKit's stand-in for Radix behind shadcn's Menubar and NavigationMenu:
// click (or hover, for nav menus) opens a menu's panel; while one is open,
// hovering a sibling trigger switches to it; Escape/outside/item click closes.
// Connects to data-controller="phlex-kit--menubar"
export default class extends Controller {
  static targets = ["menu"]

  toggle(e) {
    const menu = e.currentTarget.closest("[data-phlex-kit--menubar-target=\"menu\"]")
    this.openMenu === menu ? this.close() : this.show(menu)
  }

  // Hover: switches between menus while one is open (menubar), or opens
  // directly when the bar declares data-hover-open (navigation menu).
  switch(e) {
    const menu = e.currentTarget.closest("[data-phlex-kit--menubar-target=\"menu\"]")
    if (this.element.dataset.hoverOpen !== undefined) return this.show(menu)
    if (this.openMenu && this.openMenu !== menu) this.show(menu)
  }

  show(menu) {
    if (this.openMenu === menu) return
    this.close()
    menu.querySelector("[role=\"menu\"], .pk-menubar-content, .pk-navigation-menu-content")?.classList.remove("pk-hidden")
    menu.querySelector("[aria-expanded]")?.setAttribute("aria-expanded", "true")
    this.openMenu = menu
  }

  close() {
    const menu = this.openMenu
    if (!menu) return
    menu.querySelector("[role=\"menu\"], .pk-menubar-content, .pk-navigation-menu-content")?.classList.add("pk-hidden")
    menu.querySelector("[aria-expanded]")?.setAttribute("aria-expanded", "false")
    this.openMenu = null
  }

  onClickOutside(e) {
    if (this.element.contains(e.target)) return
    this.close()
  }
}
