import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's combobox controller. TWO changes from upstream: the
// @floating-ui/dom dependency and the native Popover API are removed — the panel
// is a CSS-positioned child of the combobox (.pk-combobox-popover, toggled with
// .pk-hidden) with click-outside handled by a window action, so only
// @hotwired/stimulus is needed. PhlexKit also COMPLETES upstream's unfinished
// input/badge trigger variants: the inputTrigger / badgeContainer / badgeInput /
// clearButton targets, filtering from whichever field fired, chip rendering
// with per-chip remove, backspace removal, and clearAll all had no upstream
// implementation. Core behaviour (trigger label, filtering, keyboard nav,
// toggle-all) is unchanged.
// Connects to data-controller="phlex-kit--combobox"
export default class extends Controller {
  static values = {
    term: String,
    minPopoverWidth: { type: Number, default: 240 },
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

  connect() {
    this.generateItemIds()
    this.updateTriggerContent()
  }

  // ARIA plumbing: every option gets an id derived from the listbox id so the
  // combobox element can point aria-activedescendant at the keyboard highlight,
  // and aria-controls is wired to the listbox (mirrors select_controller.js).
  generateItemIds() {
    const list = this.hasListTarget ? this.listTarget : (this.hasPopoverTarget ? this.popoverTarget : this.element)
    if (!list.id) list.id = `pk-combobox-list-${Math.random().toString(36).slice(2, 10)}`

    this.itemTargets.forEach((item, index) => {
      if (!item.id) item.id = `${list.id}-${index}`
    })

    this.ariaExpandedElements().forEach((el) => el.setAttribute("aria-controls", list.id))
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
    return this.hasPopoverTarget && !this.popoverTarget.classList.contains("pk-hidden")
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
    this.inputTargets.forEach(input => input.checked = isChecked)
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
    this.inputTargets.forEach(input => input.checked = false)
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
    if (event) event.preventDefault()
    if (this.isOpen()) return

    this.updatePopoverWidth()
    this.setExpanded(true)
    this.selectedItemIndex = null
    this.itemTargets.forEach(item => item.ariaCurrent = "false")
    this.clearActiveDescendant()
    this.popoverTarget.classList.remove("pk-hidden")

    const field = this.filterField()
    if (field) {
      field.focus()
      // In the input trigger the field holds the last selection — select it so
      // typing starts a fresh query.
      if (field === (this.hasInputTriggerTarget ? this.inputTriggerTarget : null)) field.select()
    }
  }

  closePopover() {
    this.setExpanded(false)
    // aria-activedescendant holds an element id; on close it must be removed,
    // not left pointing at a hidden option.
    this.clearActiveDescendant()
    this.popoverTarget.classList.add("pk-hidden")
    this.updateTriggerContent() // reflect the selection into an input trigger
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
    if (["ArrowDown", "ArrowUp", "Tab", "Enter"].includes(e.key)) {
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
    const visibleInputs = this.inputTargets.filter(input => !input.parentElement.classList.contains("pk-hidden"))
    if (visibleInputs.length === 0) return

    this.wrapSelectedInputIndex(visibleInputs.length)

    visibleInputs.forEach((input, index) => {
      if (index == this.selectedItemIndex) {
        input.parentElement.ariaCurrent = "true"
        // Focus stays in the filter field; the highlighted option is exposed
        // via aria-activedescendant (option ids come from generateItemIds).
        this.setActiveDescendant(input.parentElement.id)
        input.parentElement.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'nearest' })
      } else {
        input.parentElement.ariaCurrent = "false"
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

  updatePopoverWidth() {
    const width = Math.max(this.triggerTarget.offsetWidth, this.minPopoverWidthValue)
    this.popoverTarget.style.width = `${width}px`
  }
}
