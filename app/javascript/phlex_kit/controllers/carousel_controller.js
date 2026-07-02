import { Controller } from "@hotwired/stimulus";

const DEFAULT_OPTIONS = {
  loop: true,
  axis: "x",
};

// Ported from ruby_ui's carousel controller with the embla-carousel dependency
// removed: a minimal translate-based engine (scrollNext/scrollPrev, loop, x/y
// axis from the options value) moves the track directly, so only
// @hotwired/stimulus is needed. Button disabled state mirrors embla's
// canScrollNext/canScrollPrev.
export default class extends Controller {
  static values = {
    options: {
      type: Object,
      default: {},
    },
  };
  static targets = ["viewport", "nextButton", "prevButton"];

  connect() {
    this.index = 0;
    this.track = this.viewportTarget.firstElementChild;
    this._onResize = () => this._applyTransform();
    window.addEventListener("resize", this._onResize);
    this._update();
  }

  disconnect() {
    window.removeEventListener("resize", this._onResize);
  }

  scrollNext() {
    this._goTo(this.index + 1);
  }

  scrollPrev() {
    this._goTo(this.index - 1);
  }

  get slides() {
    return this.track ? Array.from(this.track.children) : [];
  }

  get options() {
    return { ...DEFAULT_OPTIONS, ...this.optionsValue };
  }

  _goTo(index) {
    const count = this.slides.length;
    if (count === 0) return;
    if (this.options.loop) {
      index = ((index % count) + count) % count;
    } else {
      index = Math.max(0, Math.min(index, count - 1));
    }
    this.index = index;
    this._update();
  }

  _update() {
    this._applyTransform();
    const last = this.slides.length - 1;
    const canNext = this.options.loop ? this.slides.length > 1 : this.index < last;
    const canPrev = this.options.loop ? this.slides.length > 1 : this.index > 0;
    this.nextButtonTargets.forEach((button) => (button.disabled = !canNext));
    this.prevButtonTargets.forEach((button) => (button.disabled = !canPrev));
  }

  _applyTransform() {
    const slide = this.slides[this.index];
    const first = this.slides[0];
    if (!slide || !first || !this.track) return;
    if (this.options.axis === "y") {
      this.track.style.transform = `translate3d(0, ${-(slide.offsetTop - first.offsetTop)}px, 0)`;
    } else {
      this.track.style.transform = `translate3d(${-(slide.offsetLeft - first.offsetLeft)}px, 0, 0)`;
    }
  }
}
