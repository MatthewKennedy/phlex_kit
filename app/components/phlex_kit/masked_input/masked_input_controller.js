import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--masked-input". Lightweight, dependency-
// free mask driven by a data-mask pattern (# = digit, A = letter, * = any
// alphanumeric — formatting characters are stripped before matching, so *
// cannot match punctuation; swap in `maska` (ruby_ui's choice) if you need a
// fuller mask engine).
export default class extends Controller {
  connect() {
    this.mask = this.element.getAttribute("data-mask") || ""
    if (!this.mask) return
    // Skip IME composition updates — masking mid-composition mangles the text.
    this.onInput = (e) => { if (!e.isComposing) this.apply() }
    // Some browsers (Safari) fire the final input event with isComposing still
    // true, so IME-committed text would never be masked — catch the commit here.
    this.onCompositionEnd = () => this.apply()
    this.element.addEventListener("input", this.onInput)
    this.element.addEventListener("compositionend", this.onCompositionEnd)
    // A server-prefilled value renders unmasked — format it once up front.
    if (this.element.value) this.apply()
  }
  disconnect() {
    if (this.onInput) this.element.removeEventListener("input", this.onInput)
    if (this.onCompositionEnd) this.element.removeEventListener("compositionend", this.onCompositionEnd)
  }
  apply() {
    const el = this.element
    // The whole value is rewritten below, which throws the caret to the end —
    // remember how many maskable chars sit before it and re-seat it after
    // the same count in the masked output (mid-field edits keep their place).
    const caret = el.selectionStart ?? el.value.length
    const rawBefore = this.maskable(el.value.slice(0, caret)).length

    const raw = this.maskable(el.value)
    let out = "", i = 0
    for (const t of this.mask) {
      if (i >= raw.length) break
      if (t === "#" || t === "A" || t === "*") {
        // Skip wrong-class characters instead of aborting the fill —
        // "12a34" against ##/## must yield "12/34", not "12".
        const re = t === "#" ? /\d/ : t === "A" ? /[A-Za-z]/ : /[0-9A-Za-z]/
        while (i < raw.length && !re.test(raw[i])) i++
        if (i >= raw.length) break
        out += raw[i++]
      } else { out += t; if (raw[i] === t) i++ }
    }
    el.value = out

    if (document.activeElement === el) {
      let pos = 0, seen = 0
      while (pos < out.length && seen < rawBefore) {
        if (/[0-9A-Za-z]/.test(out[pos])) seen++
        pos++
      }
      el.setSelectionRange(pos, pos)
    }
  }
  // Transliterate full-width digits (０-９, U+FF10–FF19 — common IME numeric
  // output) to ASCII before the charset filter would silently drop them.
  maskable(value) {
    return value
      .replace(/[０-９]/g, (d) => String.fromCharCode(d.charCodeAt(0) - 0xFEE0))
      .replace(/[^0-9A-Za-z]/g, "")
  }
}
