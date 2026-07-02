import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's combobox controller. TWO changes from upstream: the
// @floating-ui/dom dependency and the native Popover API are removed — the panel
// is a CSS-positioned child of the combobox (.pk-combobox-popover, toggled with
// .pk-hidden) with click-outside handled by a window action, so only
// @hotwired/stimulus is needed. Everything else (trigger label, filtering,
// keyboard nav, toggle-all) is unchanged.
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
    "triggerContent"
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
  }

  inputContent(input) {
    return input.dataset.text || input.parentElement.textContent
  }

  toggleAllItems() {
    const isChecked = this.toggleAllTarget.checked
    this.inputTargets.forEach(input => input.checked = isChecked)
    this.updateTriggerContent()
  }

  updateTriggerContent() {
    const checkedInputs = this.inputTargets.filter(input => input.checked)

    if (checkedInputs.length === 0) {
      this.triggerContentTarget.innerText = this.triggerTarget.dataset.placeholder
    } else if (this.termValue && checkedInputs.length > 1) {
      this.triggerContentTarget.innerText = `${checkedInputs.length} ${this.termValue}`
    } else {
      this.triggerContentTarget.innerText = checkedInputs.map((input) => this.inputContent(input)).join(", ")
    }
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

    this.updatePopoverWidth()
    this.triggerTarget.ariaExpanded = "true"
    this.selectedItemIndex = null
    this.itemTargets.forEach(item => item.ariaCurrent = "false")
    this.popoverTarget.classList.remove("pk-hidden")
    if (this.hasSearchInputTarget) this.searchInputTarget.focus()
  }

  closePopover() {
    this.triggerTarget.ariaExpanded = "false"
    this.popoverTarget.classList.add("pk-hidden")
  }

  onClickOutside(event) {
    if (this.triggerTarget.ariaExpanded !== "true") return
    if (this.element.contains(event.target)) return

    this.closePopover()
  }

  filterItems(e) {
    if (["ArrowDown", "ArrowUp", "Tab", "Enter"].includes(e.key)) {
      return
    }

    const filterTerm = this.searchInputTarget.value.toLowerCase()

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

    this.emptyStateTarget.classList.toggle("pk-hidden", resultCount !== 0)
  }

  keyDownPressed() {
    if (this.selectedItemIndex !== null) {
      this.selectedItemIndex++
    } else {
      this.selectedItemIndex = 0
    }

    this.focusSelectedInput()
  }

  keyUpPressed() {
    if (this.selectedItemIndex !== null) {
      this.selectedItemIndex--
    } else {
      this.selectedItemIndex = -1
    }

    this.focusSelectedInput()
  }

  focusSelectedInput() {
    const visibleInputs = this.inputTargets.filter(input => !input.parentElement.classList.contains("pk-hidden"))

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
