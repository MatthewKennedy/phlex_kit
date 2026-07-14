import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--theme-toggle". Sits on the same wrapper
// as phlex-kit--toggle; pressed = dark. Flips :root[data-theme] to match the
// PhlexKit token system (not .dark/.light classes). Adapted from ruby_ui.
export default class extends Controller {
  connect() { this.applyTheme(this.currentTheme()) }
  apply(e) {
    const theme = e.detail?.pressed ? "dark" : "light"
    // connect()'s own pressed-state sync re-enters here via the toggle's
    // change event (Stimulus value observation is async, so a flag can't
    // gate it). If the incoming theme already matches the applied one this
    // is that echo, not a user toggle — persisting it would silently pin
    // the visitor's OS preference in localStorage on first visit.
    if (theme === document.documentElement.getAttribute("data-theme")) return
    localStorage.theme = theme
    this.applyTheme(theme)
  }
  currentTheme() {
    if (localStorage.theme === "dark") return "dark"
    if (localStorage.theme === "light") return "light"
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"
  }
  applyTheme(theme) {
    document.documentElement.setAttribute("data-theme", theme)
    this.element.setAttribute("data-phlex-kit--toggle-pressed-value", theme === "dark" ? "true" : "false")
  }
}
