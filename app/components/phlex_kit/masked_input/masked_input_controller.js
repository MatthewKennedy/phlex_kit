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
    // re-seat it after the same number of TOKEN-filled (user) characters.
    // Counting is done in token space, not "any alphanumeric" space: mask
    // literals can themselves be alphanumeric (the "1" in "+1 (###) ###-####"),
    // and counting them as user input reordered every subsequent keystroke.
    const caret = el.selectionStart ?? el.value.length
    const filledBefore = this.maskFill(this.maskable(el.value.slice(0, caret))).tokenPos.length

    const { out, tokenPos } = this.maskFill(this.maskable(el.value))
    el.value = out

    if (document.activeElement === el) {
      const pos = filledBefore === 0 ? 0 : tokenPos[filledBefore - 1] + 1
      el.setSelectionRange(pos, pos)
    }
  }

  // Fill the mask from `raw`, returning the output and the output indices
  // that were filled from user input (vs emitted as mask literals).
  maskFill(raw) {
    let out = "", i = 0
    const tokenPos = []
    for (const t of this.mask) {
      if (i >= raw.length) break
      if (t === "#" || t === "A" || t === "*") {
        // Skip wrong-class characters instead of aborting the fill —
        // "12a34" against ##/## must yield "12/34", not "12".
        const re = t === "#" ? /\d/ : t === "A" ? /[A-Za-z]/ : /[0-9A-Za-z]/
        while (i < raw.length && !re.test(raw[i])) i++
        if (i >= raw.length) break
        tokenPos.push(out.length)
        out += raw[i++]
      } else { out += t; if (raw[i] === t) i++ }
    }
    return { out, tokenPos }
  }
  // Transliterate full-width digits (０-９, U+FF10–FF19 — common IME numeric
  // output) to ASCII before the charset filter would silently drop them.
  maskable(value) {
    return value
      .replace(/[０-９]/g, (d) => String.fromCharCode(d.charCodeAt(0) - 0xFEE0))
      .replace(/[^0-9A-Za-z]/g, "")
  }
}
