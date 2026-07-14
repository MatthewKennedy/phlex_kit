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
    this.element.addEventListener("input", this.onInput)
    // A server-prefilled value renders unmasked — format it once up front.
    if (this.element.value) this.apply()
  }
  disconnect() { if (this.onInput) this.element.removeEventListener("input", this.onInput) }
  apply() {
    const el = this.element
    // The whole value is rewritten below, which throws the caret to the end —
    // remember how many maskable chars sit before it and re-seat it after
    // the same count in the masked output (mid-field edits keep their place).
    const caret = el.selectionStart ?? el.value.length
    const rawBefore = el.value.slice(0, caret).replace(/[^0-9A-Za-z]/g, "").length

    const raw = el.value.replace(/[^0-9A-Za-z]/g, "")
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
}
