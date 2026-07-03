import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--context-menu". Opens at the cursor on
// contextmenu; closes on outside click or Escape. CSS positioning (no floating-ui).
export default class extends Controller {
  static targets = ["content"]
  connect() {
    this.onDoc = (e) => { if (!this.contentTarget.contains(e.target)) this.close() }
    this.onKey = (e) => { if (e.key === "Escape") this.close() }
  }
  disconnect() { document.removeEventListener("click", this.onDoc); document.removeEventListener("keydown", this.onKey) }
  open(e) {
    e.preventDefault()
    const r = this.element.getBoundingClientRect()
    this.contentTarget.style.left = `${e.clientX - r.left}px`
    this.contentTarget.style.top = `${e.clientY - r.top}px`
    this.contentTarget.classList.remove("pk-hidden")
    this.contentTarget.dataset.state = "open"
    document.addEventListener("click", this.onDoc)
    document.addEventListener("keydown", this.onKey)
  }
  close() {
    this.contentTarget.classList.add("pk-hidden")
    this.contentTarget.dataset.state = "closed"
    document.removeEventListener("click", this.onDoc)
    document.removeEventListener("keydown", this.onKey)
  }
}
