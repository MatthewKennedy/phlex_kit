import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's data-table-search controller (Stimulus-only upstream),
// identifiers renamed ruby-ui → phlex-kit. Debounces form submits and restores
// focus/caret across the Turbo Frame swap.

// Module-level map survives controller disconnect/connect across Turbo Frame swaps.
// Keyed by the search form's action URL.
const PENDING_FOCUS = new Map();

// Connects to data-controller="phlex-kit--data-table-search"
export default class extends Controller {
  static values = { delay: { type: Number, default: 300 } };

  connect() {
    this.timer = null;
    this.beforeFrameRender = this.captureBeforeRender.bind(this);
    document.addEventListener("turbo:before-frame-render", this.beforeFrameRender);
    // New instance after a Turbo Frame swap — check for captured state.
    this.restoreIfPending();
  }

  disconnect() {
    clearTimeout(this.timer);
    document.removeEventListener("turbo:before-frame-render", this.beforeFrameRender);
  }

  submit(event) {
    if (event && event.type !== "input") return;
    clearTimeout(this.timer);
    if (this.delayValue <= 0) return;
    this.timer = setTimeout(() => this.element.requestSubmit(), this.delayValue);
  }

  // Immediate, undebounced submit — used by change-driven controls like the
  // per-page select (CSP-safe replacement for an inline onchange handler).
  submitNow() {
    clearTimeout(this.timer);
    this.element.requestSubmit();
  }

  captureBeforeRender(event) {
    // Only capture for a render of the frame THIS form drives — the listener
    // is document-wide, so an unrelated frame rendering elsewhere while the
    // search input is focused would otherwise write a PENDING_FOCUS entry no
    // matching swap ever consumes, stealing focus on a later restore.
    const frame = event?.target;
    if (!frame || !this.rendersInto(frame)) return;
    const input = this.input();
    if (!input || document.activeElement !== input) return;
    PENDING_FOCUS.set(this.key(), {
      selectionStart: input.selectionStart,
      selectionEnd: input.selectionEnd
    });
  }

  // True when `frame` is the <turbo-frame> this form's submission renders: the
  // frame named by the form's data-turbo-frame, else the frame the form lives
  // inside (Turbo's default target).
  rendersInto(frame) {
    const targeted = this.element.dataset.turboFrame;
    return targeted ? frame.id === targeted : frame.contains(this.element);
  }

  restoreIfPending() {
    const state = PENDING_FOCUS.get(this.key());
    if (!state) return;
    PENDING_FOCUS.delete(this.key());
    const input = this.input();
    if (!input) return;
    input.focus();
    const len = input.value.length;
    try {
      input.setSelectionRange(
        Math.min(state.selectionStart ?? len, len),
        Math.min(state.selectionEnd ?? len, len)
      );
    } catch (e) {}
  }

  input() {
    return this.element.querySelector('input[type="search"]');
  }

  key() {
    // The key must survive the Turbo Frame swap (the form element is replaced),
    // so it's derived from stable markup: the form id when the caller set one,
    // else action URL + search-input name — two same-path forms (e.g. search
    // alongside the per-page select) must not share a focus-restore slot.
    if (this.element.id) return `#${this.element.id}`;
    return `${this.element.action || "_"}::${this.input()?.name ?? ""}`;
  }
}
