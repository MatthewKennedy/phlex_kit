import { Controller } from "@hotwired/stimulus"

// Keeps .pk-slider's filled-track width (--pk-slider-progress) in sync with
// the native range value. PhlexKit addition for shadcn's Slider — no Radix.
// Connects to data-controller="phlex-kit--slider"
export default class extends Controller {
  connect() {
    this.update()
  }

  update() {
    const el = this.element
    const min = Number(el.min || 0)
    const max = Number(el.max || 100)
    const span = max - min
    const progress = span === 0 ? 0 : ((Number(el.value) - min) / span) * 100
    el.style.setProperty("--pk-slider-progress", `${progress}%`)
  }
}
