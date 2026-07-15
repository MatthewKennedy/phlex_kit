import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's combobox controller, minus the @floating-ui/dom
// dependency: like upstream, the panel is a native popover (manual — this
// controller owns open/close and click-outside via a window action), and CSS
// anchor positioning replaces computePosition (combobox.css: trigger-width
// floor via anchor-size(), viewport-edge flip via position-try-fallbacks),
// so only @hotwired/stimulus is needed. PhlexKit also COMPLETES upstream's unfinished
// input/badge trigger variants: the inputTrigger / badgeContainer / badgeInput /
// clearButton targets, filtering from whichever field fired, chip rendering
// with per-chip remove, backspace removal, and clearAll all had no upstream
// implementation. Core behaviour (trigger label, filtering, keyboard nav,
// toggle-all) is unchanged.
// Connects to data-controller="phlex-kit--combobox"
export default class extends Controller {
  static values = {
    term: String,
    autoHighlight: { type: Boolean, default: false }
  }

  static targets = [
    "input",
    "toggleAll",
    "popover",
    "item",
    "emptyState",
    "searchInput",
    "trigger",
    "triggerContent",
    "inputTrigger",
    "badgeContainer",
    "badgeInput",
    "clearButton",
    "list",
    "liveRegion"
  ]

  selectedItemIndex = null

  initialize() {
    // Stimulus fires [target]Connected before connect(): anything
    // itemTargetConnected uses must be initialized here.
    this.itemIdCounter = 0
    this.refocusing = false
  }

  connect() {
    // A Turbo snapshot serializes aria-expanded / aria-activedescendant even
    // though :popover-open does not survive the restore — normalize here so
    // a restored page doesn't announce an open listbox over a closed combobox.
    this.setExpanded(false)
    this.clearActiveDescendant()
    this.generateItemIds()
    this.updateTriggerContent()
  }

  // ARIA plumbing: aria-controls is wired to the listbox (mirrors
  // select_controller.js); the per-option ids come from itemTargetConnected.
  generateItemIds() {
    this.ariaExpandedElements().forEach((el) => el.setAttribute("aria-controls", this.listId()))
  }

  listId() {
    const list = this.hasListTarget ? this.listTarget : (this.hasPopoverTarget ? this.popoverTarget : this.element)
    if (!list.id) list.id = `pk-combobox-list-${Math.random().toString(36).slice(2, 10)}`
    return list.id
  }

  // Every option gets an id derived from the listbox id so the combobox
  // element can point aria-activedescendant at the keyboard highlight. A
  // target callback (not a connect() loop) so options added after connect —
  // e.g. rendered in by the host — get ids too. Counter-based, so a removed
  // option's id is never reissued to a later arrival.
  itemTargetConnected(item) {
    if (!item.id) item.id = `${this.listId()}-${this.itemIdCounter++}`
  }

  // The elements carrying the open/closed combobox state: the trigger button
  // (button layout) and/or whichever filter field the layout has.
  ariaExpandedElements() {
    const els = []
    if (this.hasInputTriggerTarget) els.push(this.inputTriggerTarget)
    if (this.hasBadgeInputTarget) els.push(this.badgeInputTarget)
    if (els.length === 0 && this.hasTriggerTarget) els.push(this.triggerTarget)
    if (this.hasSearchInputTarget) els.push(this.searchInputTarget)
    return els
  }

  isOpen() {
    return this.hasPopoverTarget && this.popoverTarget.matches(":popover-open")
  }

  setExpanded(expanded) {
    this.ariaExpandedElements().forEach((el) => el.setAttribute("aria-expanded", expanded ? "true" : "false"))
  }

  setActiveDescendant(id) {
    const field = this.filterField()
    if (field) field.setAttribute("aria-activedescendant", id)
  }

  clearActiveDescendant() {
    const field = this.filterField()
    if (field) field.removeAttribute("aria-activedescendant")
  }

  inputChanged(e) {
    this.updateTriggerContent()

    if (e.target.type == "radio") {
      this.closePopover()
    }

    if (this.hasToggleAllTarget && !e.target.checked) {
      this.toggleAllTarget.checked = false
    }

    // Selecting from a chip trigger consumes the query: clear it and reshow
    // the full list for the next pick.
    if (this.hasBadgeInputTarget && this.badgeInputTarget.value !== "") {
      this.badgeInputTarget.value = ""
      this.applyFilter("")
    }
  }

  inputContent(input) {
    return (input.dataset.text || input.parentElement.textContent).trim()
  }

  checkedInputs() {
    return this.inputTargets.filter(input => input.checked)
  }

  selectionLabel(checkedInputs) {
    if (checkedInputs.length === 0) return ""
    if (this.termValue && checkedInputs.length > 1) return `${checkedInputs.length} ${this.termValue}`
    return checkedInputs.map((input) => this.inputContent(input)).join(", ")
  }

  toggleAllItems() {
    const isChecked = this.toggleAllTarget.checked
    this.inputTargets.forEach(input => {
      if (input.checked === isChecked) return
      input.checked = isChecked
      // Programmatic .checked flips fire no event — host listeners and the
      // form-field validation must still hear select-all (uncheck() does this).
      input.dispatchEvent(new Event("change", { bubbles: true }))
    })
    this.updateTriggerContent()
  }

  updateTriggerContent() {
    const checked = this.checkedInputs()

    this.syncAriaSelected()

    if (this.hasTriggerContentTarget) {
      this.triggerContentTarget.innerText = this.selectionLabel(checked) || this.triggerTarget.dataset.placeholder
    }

    // Input trigger: the field is also the filter, so only reflect the
    // selection while the popover is closed — never stomp a query mid-typing.
    if (this.hasInputTriggerTarget && !this.isOpen()) {
      this.inputTriggerTarget.value = this.selectionLabel(checked)
    }

    if (this.hasBadgeContainerTarget) {
      this.renderBadges(checked)
    }

    if (this.hasClearButtonTarget) {
      this.clearButtonTarget.classList.toggle("pk-hidden", checked.length === 0)
    }
  }

  // The chosen option(s) carry aria-selected; the option label is the ARIA
  // option, its inner input holds the real checked state.
  syncAriaSelected() {
    this.inputTargets.forEach((input) => {
      input.parentElement.setAttribute("aria-selected", input.checked ? "true" : "false")
    })
    // The toggle-all row is an option too (first row inside the listbox) —
    // keep its aria-selected in step with its checkbox.
    if (this.hasToggleAllTarget && this.toggleAllTarget.parentElement.getAttribute("role") === "option") {
      this.toggleAllTarget.parentElement.setAttribute("aria-selected", this.toggleAllTarget.checked ? "true" : "false")
    }
  }

  renderBadges(checked) {
    this.badgeContainerTarget.replaceChildren(...checked.map((input) => this.buildBadge(input)))
    this.badgeContainerTarget.classList.toggle("pk-hidden", checked.length === 0)
    this.triggerTarget.classList.toggle("has-badges", checked.length > 0)
    if (this.hasBadgeInputTarget) {
      this.badgeInputTarget.placeholder = checked.length === 0 ? (this.triggerTarget.dataset.placeholder || "") : ""
    }
  }

  buildBadge(input) {
    const text = this.inputContent(input)
    const badge = document.createElement("span")
    badge.className = "pk-combobox-badge"
    badge.append(text)

    const remove = document.createElement("button")
    remove.type = "button"
    remove.className = "pk-combobox-badge-remove"
    remove.setAttribute("aria-label", `Remove ${text}`)
    remove.textContent = "×"
    remove.addEventListener("click", (e) => {
      e.stopPropagation() // don't reopen the popover via the trigger's click action
      this.uncheck(input)
    })

    badge.append(remove)
    return badge
  }

  uncheck(input) {
    input.checked = false
    input.dispatchEvent(new Event("change", { bubbles: true })) // form-field & host listeners
    this.updateTriggerContent()
  }

  handleBadgeInputBackspace(e) {
    // Bound as a bare keydown: "backspace" is not a Stimulus key filter.
    if (e.key !== "Backspace") return
    if (this.badgeInputTarget.value !== "") return

    const checked = this.checkedInputs()
    const last = checked[checked.length - 1]
    if (!last) return

    e.preventDefault()
    this.uncheck(last)
  }

  clearAll(e) {
    if (e) {
      e.preventDefault()
      e.stopPropagation() // the button sits inside the trigger's click-to-open area
    }
    this.inputTargets.forEach(input => {
      if (!input.checked) return
      input.checked = false
      input.dispatchEvent(new Event("change", { bubbles: true })) // see toggleAllItems
    })
    if (this.hasToggleAllTarget) this.toggleAllTarget.checked = false
    this.updateTriggerContent()
  }

  togglePopover(event) {
    event.preventDefault()

    if (this.isOpen()) {
      this.closePopover()
    } else {
      this.openPopover(event)
    }
  }

  openPopover(event) {
    // The remove-× on a chip and the clear-all button live inside the badge
    // trigger, whose focusin (and click) actions open the popover — clicking
    // them must not reopen it (stopPropagation covers click but focusin still
    // fires when the button takes focus).
    if (event?.target?.closest?.(".pk-combobox-badge-remove, .pk-combobox-clear-button")) return
    // closePopover's focus restore fires the input/badge wrapper's
    // focusin->openPopover action synchronously — don't bounce straight back open.
    if (this.refocusing) return
    if (event) event.preventDefault()
    if (this.isOpen()) return

    this.setExpanded(true)
    this.selectedItemIndex = null
    this.itemTargets.forEach(item => item.ariaCurrent = "false")
    this.clearActiveDescendant()
    this.popoverTarget.showPopover()

    const field = this.filterField()
    if (field) {
      field.focus()
      // In the input trigger the field holds the last selection — select it so
      // typing starts a fresh query.
      if (field === (this.hasInputTriggerTarget ? this.inputTriggerTarget : null)) field.select()
    }
  }

  closePopover(e) {
    // Escape must keep its browser default (e.g. cancelling an enclosing
    // <dialog>) when the popover is already closed — only swallow the key
    // when this close actually consumes it.
    if (e?.type === "keydown") {
      if (!this.isOpen()) return
      e.preventDefault()
    }
    // Hiding the popover while focus is inside it (search input, option) drops
    // focus to <body>; hand it back to the trigger. Checked BEFORE hiding, and
    // only when focus would actually be orphaned — a click elsewhere on the
    // page (onClickOutside) must not have its focus stolen.
    const focusWasInside = this.hasPopoverTarget && this.popoverTarget.contains(document.activeElement)

    this.setExpanded(false)
    // aria-activedescendant holds an element id; on close it must be removed,
    // not left pointing at a hidden option.
    this.clearActiveDescendant()
    if (this.hasPopoverTarget && this.popoverTarget.matches(":popover-open")) this.popoverTarget.hidePopover()
    this.updateTriggerContent() // reflect the selection into an input trigger

    if (focusWasInside) {
      const field = this.filterField()
      // Input/badge layouts: back to the filter field (it lives outside the
      // popover). Button layout: back to the trigger button (its search input
      // is inside the popover, now hidden).
      const anchor = (field && !this.popoverTarget.contains(field)) ? field : (this.hasTriggerTarget ? this.triggerTarget : null)
      // focus() dispatches focusin synchronously; the flag stops the
      // wrapper's focusin->openPopover action from reopening the panel.
      this.refocusing = true
      anchor?.focus()
      this.refocusing = false
    }
  }

  onClickOutside(event) {
    if (!this.isOpen()) return
    if (this.element.contains(event.target)) return

    this.closePopover()
  }

  // Whichever filter field this layout has: popover search, input trigger, or
  // badge trigger field.
  filterField() {
    if (this.hasSearchInputTarget) return this.searchInputTarget
    if (this.hasInputTriggerTarget) return this.inputTriggerTarget
    if (this.hasBadgeInputTarget) return this.badgeInputTarget
    return null
  }

  filterItems(e) {
    // Escape's keyup arrives after keydown.esc already closed the popover —
    // re-running the filter then would wipe the highlight state for nothing.
    if (["ArrowDown", "ArrowUp", "Tab", "Enter", "Escape"].includes(e.key)) {
      return
    }

    const field = (e.target instanceof HTMLInputElement) ? e.target : this.filterField()
    if (!field) return

    this.applyFilter(field.value.toLowerCase())
  }

  applyFilter(filterTerm) {
    if (this.hasToggleAllTarget) {
      if (filterTerm) this.toggleAllTarget.parentElement.classList.add("pk-hidden")
      else this.toggleAllTarget.parentElement.classList.remove("pk-hidden")
    }

    let resultCount = 0

    this.selectedItemIndex = null
    this.clearActiveDescendant()
    // Also drop the highlight itself: a filtered-out option that kept
    // aria-current="true" stayed the Enter target while invisible.
    this.itemTargets.forEach(item => item.ariaCurrent = "false")

    this.inputTargets.forEach((input) => {
      const text = this.inputContent(input).toLowerCase()

      if (text.indexOf(filterTerm) > -1) {
        input.parentElement.classList.remove("pk-hidden")
        resultCount++
      } else {
        input.parentElement.classList.add("pk-hidden")
      }
    })

    if (this.hasEmptyStateTarget) {
      this.emptyStateTarget.classList.toggle("pk-hidden", resultCount !== 0)
    }

    // Announce the filtered result count to screen readers.
    if (this.hasLiveRegionTarget) {
      this.liveRegionTarget.textContent =
        resultCount === 0 ? "No results" : `${resultCount} result${resultCount === 1 ? "" : "s"}`
    }

    // autoHighlight: keep the first visible option marked while typing so
    // Enter picks it immediately (their autoHighlight prop).
    if (this.autoHighlightValue && filterTerm && resultCount > 0) {
      this.selectedItemIndex = 0
      this.focusSelectedInput()
    }
  }

  keyDownPressed(e) {
    if (e) e.preventDefault()

    if (this.selectedItemIndex !== null) {
      this.selectedItemIndex++
    } else {
      this.selectedItemIndex = 0
    }

    this.focusSelectedInput()
  }

  keyUpPressed(e) {
    if (e) e.preventDefault()

    if (this.selectedItemIndex !== null) {
      this.selectedItemIndex--
    } else {
      this.selectedItemIndex = -1
    }

    this.focusSelectedInput()
  }

  focusSelectedInput() {
    // Walk the option rows themselves, not the inner selection inputs: the
    // toggle-all row is an option without an "input" target and must be
    // arrow-reachable like any other option.
    const visibleItems = this.itemTargets.filter(item => !item.classList.contains("pk-hidden"))
    if (visibleItems.length === 0) return

    this.wrapSelectedInputIndex(visibleItems.length)

    visibleItems.forEach((item, index) => {
      if (index == this.selectedItemIndex) {
        item.ariaCurrent = "true"
        // Focus stays in the filter field; the highlighted option is exposed
        // via aria-activedescendant (option ids come from generateItemIds).
        this.setActiveDescendant(item.id)
        item.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'nearest' })
      } else {
        item.ariaCurrent = "false"
      }
    })
  }

  keyEnterPressed(event) {
    event.preventDefault()
    const option = this.itemTargets.find(item => item.ariaCurrent === "true")

    if (option) {
      option.click()
    }
  }

  wrapSelectedInputIndex(length) {
    this.selectedItemIndex = ((this.selectedItemIndex % length) + length) % length
  }

}
