import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--clipboard". Copies the source text and
// flashes a success/error popover (CSS-positioned, no @floating-ui). Ported from ruby_ui.
export default class extends Controller {
  // No "trigger" target: the click->#copy action alone wires the trigger.
  static targets = ["source", "successPopover", "errorPopover"]

  connect() {
    // Turbo snapshots at turbo:before-cache, BEFORE disconnect — hide the
    // flash now or a restore shows a permanently stuck "Copied!" popover.
    document.addEventListener("turbo:before-cache", this.beforeCache)
  }

  disconnect() {
    // Don't leave the 1.5s hide timer running into a dead/recycled element
    // (Turbo can detach and re-attach this subtree mid-flash).
    clearTimeout(this.timer)
    document.removeEventListener("turbo:before-cache", this.beforeCache)
    this.hideAll()
  }

  beforeCache = () => {
    clearTimeout(this.timer)
    this.hideAll()
  }

  copy() {
    // A source usually wraps one element (input/code/…), but bare text is
    // legal too — fall back to the source's own text instead of erroring.
    const el = this.sourceTarget.children[0]
    // TEXTAREA reads .value like INPUT — innerText would return the initial
    // content, not the user-edited value.
    const text = el
      ? (["INPUT", "TEXTAREA"].includes(el.tagName) ? el.value : el.innerText)
      : this.sourceTarget.textContent.trim()
    if (!text) { this.show(this.errorPopoverTarget); return }
    // navigator.clipboard is undefined in insecure contexts (plain-HTTP
    // hosts, some webviews) — that's the error popover's job, not an
    // unhandled TypeError's.
    if (!navigator.clipboard) { this.show(this.errorPopoverTarget); return }
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
