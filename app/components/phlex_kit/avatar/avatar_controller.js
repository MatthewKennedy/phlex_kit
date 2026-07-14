import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's phlex-kit--avatar controller. Shows the image once it
// has loaded (else the fallback). With no image target (fallback-only avatar)
// connect() no-ops and the fallback stays visible. Purely progressive
// enhancement: the CSS stacks the image over the fallback, so with no JS a
// loaded image covers the fallback and a failed one leaves it showing. Uses
// the kit's .pk-hidden utility (not a bare .hidden).
export default class extends Controller {
  static targets = ["image", "fallback"];

  connect() {
    if (!this.hasImageTarget) {
      return;
    }

    if (this.imageTarget.complete && this.imageTarget.naturalWidth > 0) {
      this.showImage();
    } else {
      this.showFallback();
    }
  }

  showImage() {
    this.imageTargets.forEach((image) => image.classList.remove("pk-hidden"));
    this.fallbackTargets.forEach((fallback) => fallback.classList.add("pk-hidden"));
  }

  showFallback() {
    this.imageTargets.forEach((image) => image.classList.add("pk-hidden"));
    this.fallbackTargets.forEach((fallback) => fallback.classList.remove("pk-hidden"));
  }
}
