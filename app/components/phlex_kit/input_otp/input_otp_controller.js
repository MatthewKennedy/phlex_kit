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
    // Slots compose without knowing their position, so `length:` can drift
    // from the actual slot count — flag the mismatch instead of silently
    // truncating/underfilling codes.
    if (this.hasLengthValue && this.lengthValue !== this.slotTargets.length) {
      console.warn(`phlex-kit--input-otp: length is ${this.lengthValue} but ${this.slotTargets.length} slots rendered`, this.element)
    }
    // Slots compose without knowing their position — label them here so AT
    // announces "Digit N of M" instead of anonymous edit fields.
    this.slotTargets.forEach((slot, i) => {
      if (!slot.hasAttribute("aria-label")) {
        slot.setAttribute("aria-label", `Digit ${i + 1} of ${this.slotTargets.length}`)
      }
    })
    // A server-provided value renders on the hidden input only — distribute
    // it into the empty slots BEFORE syncing, or syncValue would join the
    // empty slots and wipe the value with a spurious change event.
    if (this.hasValueTarget && this.valueTarget.value && this.slotTargets.every((slot) => !slot.value)) {
      const chars = this.valueTarget.value.split("")
      this.slotTargets.forEach((slot, i) => { if (chars[i] != null) slot.value = chars[i] })
    }
    // Track each slot's last-known-good value so a rejected keystroke (see
    // onInput) can restore it instead of leaving the slot blanked.
    this.slotTargets.forEach((slot) => { slot.dataset.otpValue = slot.value })
    this.syncValue()
  }

  onInput(e) {
    const slot = e.target
    const isNumeric = slot.getAttribute("inputmode") === "numeric"
    const priorValue = slot.dataset.otpValue || ""
    let text = slot.value.replace(/\s/g, "")
    // Typing rejects the same characters paste strips — a letter keyed into
    // an inputmode=numeric slot must not land.
    if (isNumeric) text = text.replace(/\D/g, "")

    if (text.length > 1) {
      if (e.data && e.data.length === 1) {
        if (isNumeric && !/\d/.test(e.data)) {
          // Rejected keystroke into an already-filled/selected slot: restore
          // the prior digit rather than blanking it, and don't advance focus.
          slot.value = priorValue
          return
        }
        // one keystroke into an already-filled slot: keep the newest char
        slot.value = e.data
        slot.dataset.otpValue = e.data
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

    if (!text && e.data) {
      // A keystroke was fully rejected by numeric filtering (e.g. a letter
      // typed into a filled/selected slot) — restore the slot's prior value
      // instead of blanking it, and don't advance focus.
      slot.value = priorValue
      return
    }

    slot.value = text
    slot.dataset.otpValue = text
    if (slot.value) this.focusSlot(this.slotTargets.indexOf(slot) + 1)
    this.syncValue()
  }

  onKeydown(e) {
    const index = this.slotTargets.indexOf(e.target)
    if (e.key === "Backspace" && !e.target.value && index > 0) {
      e.preventDefault()
      const prev = this.slotTargets[index - 1]
      prev.value = ""
      prev.dataset.otpValue = ""
      prev.focus()
      this.syncValue()
    } else if (e.key === "ArrowLeft" || e.key === "ArrowRight") {
      // The slot row mirrors in RTL (all logical CSS), so the physical
      // arrows flip: ArrowLeft moves toward the NEXT slot there. Runtime
      // dir check — reliable after a dynamic flip, unlike :dir().
      const rtl = getComputedStyle(this.element).direction === "rtl"
      const delta = (e.key === "ArrowLeft") !== rtl ? -1 : 1
      if (delta === -1 && index === 0) return
      e.preventDefault()
      this.focusSlot(index + delta)
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
    // A full-length (or longer) code is distributed from the FIRST slot no
    // matter which one is focused — pasting a complete code into a middle
    // slot otherwise silently truncated it (only the slots from focus onward
    // got filled) and merged the run with whatever digits sat before it.
    // A shorter (partial) paste still fills from the focused slot.
    const start = chars.length >= this.slotTargets.length ? 0 : this.slotTargets.indexOf(slot)
    this.slotTargets.slice(start).forEach((s, i) => { if (chars[i] != null) { s.value = chars[i]; s.dataset.otpValue = chars[i] } })
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
