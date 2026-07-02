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
    minPopoverWidth: { type: Number, default: 240 }
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
    "clearButton"
  ]

  selectedItemIndex = null

  connect() {
    this.updateTriggerContent()
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

    if (this.hasTriggerContentTarget) {
      this.triggerContentTarget.innerText = this.selectionLabel(checked) || this.triggerTarget.dataset.placeholder
    }

    // Input trigger: the field is also the filter, so only reflect the
    // selection while the popover is closed — never stomp a query mid-typing.
    if (this.hasInputTriggerTarget && this.triggerTarget.ariaExpanded !== "true") {
      this.inputTriggerTarget.value = this.selectionLabel(checked)
    }

    if (this.hasBadgeContainerTarget) {
      this.renderBadges(checked)
    }

    if (this.hasClearButtonTarget) {
      this.clearButtonTarget.classList.toggle("pk-hidden", checked.length === 0)
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

    if (this.triggerTarget.ariaExpanded === "true") {
      this.closePopover()
    } else {
      this.openPopover(event)
    }
  }

  openPopover(event) {
    if (event) event.preventDefault()
    if (this.triggerTarget.ariaExpanded === "true") return

    this.updatePopoverWidth()
    this.triggerTarget.ariaExpanded = "true"
    this.selectedItemIndex = null
    this.itemTargets.forEach(item => item.ariaCurrent = "false")
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
    this.triggerTarget.ariaExpanded = "false"
    this.popoverTarget.classList.add("pk-hidden")
    this.updateTriggerContent() // reflect the selection into an input trigger
  }

  onClickOutside(event) {
    if (this.triggerTarget.ariaExpanded !== "true") return
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
