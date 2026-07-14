import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--theme-toggle". Sits on the same wrapper
// as phlex-kit--toggle; pressed = dark. Flips :root[data-theme] to match the
// PhlexKit token system (not .dark/.light classes). Adapted from ruby_ui.
//
// With no stored choice the root is stamped data-theme="system" — _tokens.css
// resolves that via prefers-color-scheme, and the matchMedia listener below
// keeps the toggle's pressed state live when the OS preference flips. Only an
// explicit user toggle persists "dark"/"light". localStorage access is
// try/catch-wrapped (storage-blocked contexts): the toggle then still works,
// just non-persistently, via the in-memory fallback.
export default class extends Controller {
  connect() {
    this._media = window.matchMedia("(prefers-color-scheme: dark)")
    this._onMediaChange = () => {
      // Only re-apply while the user has no explicit choice.
      if (!this.storedTheme()) this.applyTheme("system")
    }
    this._media.addEventListener("change", this._onMediaChange)
    this.applyTheme(this.storedTheme() || "system")
  }

  disconnect() {
    this._media?.removeEventListener("change", this._onMediaChange)
  }

  apply(e) {
    const theme = e.detail?.pressed ? "dark" : "light"
    // connect()'s own pressed-state sync re-enters here via the toggle's
    // change event (Stimulus value observation is async, so a flag can't
    // gate it). If the incoming theme already matches the resolved one this
    // is that echo, not a user toggle — persisting it would silently pin
    // the visitor's OS preference in localStorage on first visit.
    if (theme === this.resolvedTheme()) return
    this.storeTheme(theme)
    this.applyTheme(theme)
  }

  // The user's explicit choice, if any ("dark"/"light"), else null.
  storedTheme() {
    try {
      const t = localStorage.theme
      if (t === "dark" || t === "light") return t
    } catch {}
    return this._fallbackTheme || null
  }

  storeTheme(theme) {
    this._fallbackTheme = theme
    try { localStorage.theme = theme } catch {}
  }

  // The theme actually in effect right now: explicit choice, else OS.
  resolvedTheme() {
    return this.storedTheme() || (this._media.matches ? "dark" : "light")
  }

  applyTheme(theme) {
    document.documentElement.setAttribute("data-theme", theme)
    const dark = theme === "system" ? this._media.matches : theme === "dark"
    this.element.setAttribute("data-phlex-kit--toggle-pressed-value", dark ? "true" : "false")
  }
}
