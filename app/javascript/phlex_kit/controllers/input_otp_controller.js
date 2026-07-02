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
    this.syncValue()
  }

  onInput(e) {
    const slot = e.target
    slot.value = slot.value.replace(/\s/g, "").slice(-1)
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
    const chars = (e.clipboardData?.getData("text") || "").replace(/\s/g, "").split("")
    if (!chars.length) return
    const start = this.slotTargets.indexOf(e.target)
    this.slotTargets.slice(start).forEach((slot, i) => { if (chars[i] != null) slot.value = chars[i] })
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
