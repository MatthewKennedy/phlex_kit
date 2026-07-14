import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--clipboard". Copies the source text and
// flashes a success/error popover (CSS-positioned, no @floating-ui). Ported from ruby_ui.
export default class extends Controller {
  static targets = ["trigger", "source", "successPopover", "errorPopover"]

  disconnect() {
    // Don't leave the 1.5s hide timer running into a dead/recycled element
    // (Turbo can detach and re-attach this subtree mid-flash).
    clearTimeout(this.timer)
    this.hideAll()
  }

  copy() {
    const el = this.sourceTarget.children[0]
    if (!el) { this.show(this.errorPopoverTarget); return }
    const text = el.tagName === "INPUT" ? el.value : el.innerText
    navigator.clipboard.writeText(text)
      .then(() => this.show(this.successPopoverTarget))
      .catch(() => this.show(this.errorPopoverTarget))
  }

  onClickOutside(e) { if (!this.element.contains(e.target)) this.hideAll() }

  show(target) {
    this.hideAll()
    target.classList.remove("pk-hidden")
    clearTimeout(this.timer)
    this.timer = setTimeout(() => target.classList.add("pk-hidden"), 1500)
  }

  hideAll() {
    this.successPopoverTarget.classList.add("pk-hidden")
    this.errorPopoverTarget.classList.add("pk-hidden")
  }
}
