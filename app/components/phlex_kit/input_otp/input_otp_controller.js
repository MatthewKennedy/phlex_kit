import { Controller } from "@hotwired/stimulus"

// PhlexKit's stand-in for the input-otp lib behind shadcn's InputOTP: per-slot
// single-character inputs with auto-advance, backspace retreat, arrow
// movement and paste distribution; the hidden value target carries the joined
// code for the form.
// Connects to data-controller="phlex-kit--input-otp"
export default class extends Controller {
  static targets = ["slot", "value"]
  static values = { length: Number }

  connect() {
    // Slots compose without knowing their position — label them here so AT
    // announces "Digit N of M" instead of anonymous edit fields.
    this.slotTargets.forEach((slot, i) => {
      if (!slot.hasAttribute("aria-label")) {
        slot.setAttribute("aria-label", `Digit ${i + 1} of ${this.slotTargets.length}`)
      }
    })
    this.syncValue()
  }

  onInput(e) {
    const slot = e.target
    let text = slot.value.replace(/\s/g, "")
    // Typing rejects the same characters paste strips — a letter keyed into
    // an inputmode=numeric slot must not land.
    if (slot.getAttribute("inputmode") === "numeric") text = text.replace(/\D/g, "")

    if (text.length > 1) {
      if (e.data && e.data.length === 1) {
        // one keystroke into an already-filled slot: keep the newest char
        slot.value = e.data
        this.focusSlot(this.slotTargets.indexOf(slot) + 1)
        this.syncValue()
      } else {
        // OTP autofill (autocomplete="one-time-code") delivers the whole
        // code into the focused slot — distribute it like a paste instead
        // of discarding all but one digit.
        this.fillFrom(slot, text)
      }
      return
    }

    slot.value = text
    if (slot.value) this.focusSlot(this.slotTargets.indexOf(slot) + 1)
    this.syncValue()
  }

  onKeydown(e) {
    const index = this.slotTargets.indexOf(e.target)
    if (e.key === "Backspace" && !e.target.value && index > 0) {
      e.preventDefault()
      const prev = this.slotTargets[index - 1]
      prev.value = ""
      prev.focus()
      this.syncValue()
    } else if (e.key === "ArrowLeft" && index > 0) {
      e.preventDefault()
      this.focusSlot(index - 1)
    } else if (e.key === "ArrowRight") {
      e.preventDefault()
      this.focusSlot(index + 1)
    }
  }

  onPaste(e) {
    e.preventDefault()
    let text = (e.clipboardData?.getData("text") || "").replace(/\s/g, "")
    // Numeric slots reject non-digits on typing; pasted text like
    // "code: 123456" should distribute only the digits.
    if (e.target.getAttribute("inputmode") === "numeric") text = text.replace(/\D/g, "")
    if (!text.length) return
    this.fillFrom(e.target, text)
  }

  // Distribute a multi-character string across the slots starting at `slot`
  // (shared by paste and autofill), then park focus after the last filled one.
  fillFrom(slot, text) {
    const chars = text.split("")
    const start = this.slotTargets.indexOf(slot)
    this.slotTargets.slice(start).forEach((s, i) => { if (chars[i] != null) s.value = chars[i] })
    this.focusSlot(Math.min(start + chars.length, this.slotTargets.length - 1))
    this.syncValue()
  }

  onFocus(e) {
    e.target.select()
  }

  focusSlot(index) {
    const slot = this.slotTargets[Math.max(0, Math.min(index, this.slotTargets.length - 1))]
    slot?.focus()
  }

  syncValue() {
    if (!this.hasValueTarget) return
    const code = this.slotTargets.map((slot) => slot.value).join("")
    if (this.valueTarget.value === code) return
    this.valueTarget.value = code
    this.valueTarget.dispatchEvent(new Event("change", { bubbles: true }))
  }
}
