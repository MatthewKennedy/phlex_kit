import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--masked-input". Lightweight, dependency-
// free mask driven by a data-mask pattern (# = digit, A = letter, * = any). Swap
// in `maska` (ruby_ui's choice) here if you need a fuller mask engine.
export default class extends Controller {
  connect() {
    this.mask = this.element.getAttribute("data-mask") || ""
    if (!this.mask) return
    this.onInput = () => this.apply()
    this.element.addEventListener("input", this.onInput)
  }
  disconnect() { if (this.onInput) this.element.removeEventListener("input", this.onInput) }
  apply() {
    const raw = this.element.value.replace(/[^0-9A-Za-z]/g, "")
    let out = "", i = 0
    for (const t of this.mask) {
      if (i >= raw.length) break
      if (t === "#") { if (/\d/.test(raw[i])) out += raw[i++]; else break }
      else if (t === "A") { if (/[A-Za-z]/.test(raw[i])) out += raw[i++]; else break }
      else if (t === "*") { out += raw[i++] }
      else { out += t; if (raw[i] === t) i++ }
    }
    this.element.value = out
  }
}
