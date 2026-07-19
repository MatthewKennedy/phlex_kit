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
    // Multiple toggles on one page (header + mobile menu): each instance
    // observes :root[data-theme] so a change applied by ANY of them (or by
    // host code) re-syncs every toggle's pressed state — without this the
    // stale one showed the wrong state and its first click was eaten by the
    // echo guard in apply().
    this._rootObserver = new MutationObserver(() => this.syncPressed())
    this._rootObserver.observe(document.documentElement, { attributes: true, attributeFilter: ["data-theme"] })
    // Cross-tab sync: `storage` fires only in OTHER tabs when localStorage.theme
    // changes, so another tab's toggle re-applies here. Without this, this tab's
    // DOM went stale while storedTheme() (read fresh from localStorage) already
    // returned the new value — the echo guard in apply() then swallowed a
    // genuine click because resolvedTheme() already matched.
    this._onStorage = (e) => {
      if (e.key !== "theme") return
      this.applyTheme(this.storedTheme() || "system")
    }
    window.addEventListener("storage", this._onStorage)
    this.applyTheme(this.storedTheme() || "system")
  }

  disconnect() {
    this._media?.removeEventListener("change", this._onMediaChange)
    this._rootObserver?.disconnect()
    window.removeEventListener("storage", this._onStorage)
  }

  syncPressed() {
    const theme = document.documentElement.getAttribute("data-theme") || "system"
    const dark = theme === "system" ? this._media.matches : theme === "dark"
    this.element.setAttribute("data-phlex-kit--toggle-pressed-value", dark ? "true" : "false")
  }

  apply(e) {
    const theme = e.detail?.pressed ? "dark" : "light"
    // Skip when this isn't a genuine user toggle — two echo shapes:
    // - the incoming theme already matches the RESOLVED one: connect()'s own
    //   pressed-state sync re-enters here via the toggle's change event
    //   (Stimulus value observation is async, so a flag can't gate it), and a
    //   "system" resolution lands here too — persisting either would silently
    //   pin the visitor's OS preference in localStorage on first visit.
    // - the root's data-theme ALREADY equals it: host code (or a cross-tab
    //   storage sync) wrote the theme directly. The contract is that only a
    //   user toggle persists, and a real user toggle reaches here BEFORE
    //   applyTheme updates the root, so the root still holds the OLD value —
    //   a match therefore means "not a user action, don't persist".
    const rootTheme = document.documentElement.getAttribute("data-theme")
    if (theme === this.resolvedTheme() || theme === rootTheme) return
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
