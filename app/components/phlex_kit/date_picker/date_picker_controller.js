import { Controller } from "@hotwired/stimulus"

// Bridges the nested Calendar's change event to the wrapping Popover's
// close(), so picking a date collapses the panel instead of leaving the
// user to click outside/Escape after every pick (shadcn's DatePicker
// behavior). Only closes on a COMPLETE selection: single mode closes on
// any pick, range mode only once the second end (rangeEnd) is set — closing
// on the first end would strand the user before they can pick the second —
// and multiple mode never auto-closes since picking more than one date is
// the entire point. See date_picker.rb for the data-action wiring and
// popover_controller.js for close()/focusTrigger().
export default class extends Controller {
  onCalendarChange(e) {
    const { mode, rangeEnd } = e.detail
    if (mode === "multiple") return
    // calendar_controller.js clears rangeEnd by assigning undefined (Stimulus
    // removes the attribute), so an unset rangeEnd reads back as null here.
    if (mode === "range" && !rangeEnd) return
    this.popoverController()?.close()
  }

  popoverController() {
    const popoverEl = this.element.querySelector(".pk-popover")
    return popoverEl && this.application.getControllerForElementAndIdentifier(popoverEl, "phlex-kit--popover")
  }
}
