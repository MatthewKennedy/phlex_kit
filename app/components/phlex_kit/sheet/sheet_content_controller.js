import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phlex-kit--sheet-content" (on the cloned node).
export default class extends Controller {
  close() { this.element.remove() }
}
