import { Controller } from "@hotwired/stimulus";

const DEFAULT_OPTIONS = {
  loop: true,
  axis: "x",
};

// How far (fraction of a slide) or how fast (px/ms) a drag must travel to
// advance instead of snapping back — tuned to embla's feel.
const DRAG_DISTANCE_THRESHOLD = 0.25;
const DRAG_VELOCITY_THRESHOLD = 0.5;

// Ported from ruby_ui's carousel controller with the embla-carousel dependency
// removed: a minimal translate-based engine (scrollNext/scrollPrev, loop, x/y
// axis from the options value) moves the track directly, so only
// @hotwired/stimulus is needed. Button disabled state mirrors embla's
// canScrollNext/canScrollPrev, and pointer drag/swipe (threshold + velocity,
// rubber-band at the ends when not looping, click suppression after a drag)
// replaces embla's gesture engine.
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
    this.drag = null;
    this.suppressClick = false;
    this._onResize = () => this._applyTransform();
    this._onPointerDown = this._onPointerDown.bind(this);
    this._onPointerMove = this._onPointerMove.bind(this);
    this._onPointerUp = this._onPointerUp.bind(this);
    this._onClickCapture = this._onClickCapture.bind(this);
    window.addEventListener("resize", this._onResize);
    // window resize misses container-only resizes (flex/grid reflow,
    // sidebar toggles) — observe the viewport itself.
    if (typeof ResizeObserver !== "undefined") {
      this._resizeObserver = new ResizeObserver(() => this._applyTransform());
      this._resizeObserver.observe(this.viewportTarget);
    }
    this.viewportTarget.addEventListener("pointerdown", this._onPointerDown);
    this.viewportTarget.addEventListener("click", this._onClickCapture, true);
    this._update();
  }

  disconnect() {
    window.removeEventListener("resize", this._onResize);
    this._resizeObserver?.disconnect();
    this._resizeObserver = null;
    this.viewportTarget.removeEventListener("pointerdown", this._onPointerDown);
    this.viewportTarget.removeEventListener("click", this._onClickCapture, true);
    // a disconnect mid-drag must drop the move/up listeners and drag state
    this.viewportTarget.removeEventListener("pointermove", this._onPointerMove);
    this.viewportTarget.removeEventListener("pointerup", this._onPointerUp);
    this.viewportTarget.removeEventListener("pointercancel", this._onPointerUp);
    if (this.drag) {
      this.drag = null;
      if (this.track) this.track.style.transition = "";
      this.viewportTarget.classList.remove("dragging");
    }
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
    if (!this.slides[this.index]) return;
    this._translateTo(this._offsetOf(this.index));
  }

  // --- drag/swipe ---

  _onPointerDown(e) {
    if (e.button !== 0 || this.slides.length < 2) return;
    this.suppressClick = false;
    this.drag = {
      start: this._pointerPos(e),
      startedAt: performance.now(),
      offset: this._offsetOf(this.index),
      delta: 0,
      moved: false,
    };
    try { this.viewportTarget.setPointerCapture(e.pointerId); } catch {}
    this.viewportTarget.addEventListener("pointermove", this._onPointerMove);
    this.viewportTarget.addEventListener("pointerup", this._onPointerUp);
    this.viewportTarget.addEventListener("pointercancel", this._onPointerUp);
  }

  _onPointerMove(e) {
    const drag = this.drag;
    if (!drag) return;
    drag.delta = this._pointerPos(e) - drag.start;
    if (!drag.moved && Math.abs(drag.delta) > 5) {
      drag.moved = true;
      this.track.style.transition = "none";
      this.viewportTarget.classList.add("dragging");
    }
    if (!drag.moved) return;

    let offset = drag.offset - drag.delta;
    if (!this.options.loop) {
      // rubber-band past the ends
      const max = this._offsetOf(this.slides.length - 1);
      if (offset < 0) offset = offset / 3;
      if (offset > max) offset = max + (offset - max) / 3;
    }
    this._translateTo(offset);
  }

  _onPointerUp() {
    const drag = this.drag;
    this.drag = null;
    this.viewportTarget.removeEventListener("pointermove", this._onPointerMove);
    this.viewportTarget.removeEventListener("pointerup", this._onPointerUp);
    this.viewportTarget.removeEventListener("pointercancel", this._onPointerUp);
    if (!drag || !drag.moved) return;

    this.track.style.transition = "";
    this.viewportTarget.classList.remove("dragging");
    this.suppressClick = true; // a drag must not activate links in the slide

    const elapsed = Math.max(performance.now() - drag.startedAt, 1);
    const velocity = Math.abs(drag.delta) / elapsed;
    const passed = Math.abs(drag.delta) > this._slideSize() * DRAG_DISTANCE_THRESHOLD
      || velocity > DRAG_VELOCITY_THRESHOLD;

    if (passed) {
      drag.delta < 0 ? this.scrollNext() : this.scrollPrev();
    } else {
      this._applyTransform(); // snap back
    }
  }

  _onClickCapture(e) {
    if (!this.suppressClick) return;
    this.suppressClick = false;
    e.preventDefault();
    e.stopPropagation();
  }

  // --- geometry ---

  _pointerPos(e) {
    return this.options.axis === "y" ? e.clientY : e.clientX;
  }

  _offsetOf(index) {
    const slide = this.slides[index];
    const first = this.slides[0];
    if (!slide || !first) return 0;
    const raw = this.options.axis === "y"
      ? slide.offsetTop - first.offsetTop
      : slide.offsetLeft - first.offsetLeft;
    // Never scroll past the content edge: with multi-up layouts the last
    // slides' offsets overshoot the max scrollable offset (track − viewport).
    return Math.min(Math.max(0, raw), this._maxOffset());
  }

  _maxOffset() {
    const vertical = this.options.axis === "y";
    const trackSize = vertical ? this.track.scrollHeight : this.track.scrollWidth;
    const viewportSize = vertical ? this.viewportTarget.clientHeight : this.viewportTarget.clientWidth;
    return Math.max(0, trackSize - viewportSize);
  }

  _slideSize() {
    const slide = this.slides[this.index];
    if (!slide) return 1;
    return (this.options.axis === "y" ? slide.offsetHeight : slide.offsetWidth) || 1;
  }

  _translateTo(offset) {
    this.track.style.transform = this.options.axis === "y"
      ? `translate3d(0, ${-offset}px, 0)`
      : `translate3d(${-offset}px, 0, 0)`;
  }
}
