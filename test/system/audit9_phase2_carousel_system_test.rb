# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 9, phase 2 — loop-mode multi-up carousels produced dead Next/Prev
# clicks. carousel_controller.js's _offsetOf clamps every offset to _maxOffset()
# (track − viewport); with a basis-1/3 layout the track hits that max before
# this.index reaches the last slide. The old advance guard bailed only when
# !loop, so in loop mode (the default) the index kept climbing past the last
# reachable offset — several Next presses left the transform pinned at the max
# before the index finally wrapped. Fix: wrap to the start the moment the track
# is at its max offset, so every click moves.
class Audit9Phase2CarouselSystemTest < SystemTestCase
  include InteractionHelpers

  def track_transform(section)
    section.evaluate_script(<<~JS)
      this.querySelector("[data-phlex-kit--carousel-target='viewport']").firstElementChild.style.transform
    JS
  end

  def next_button(section)
    section.find("button.pk-carousel-next", visible: :all)
  end

  def prev_button(section)
    section.find("button.pk-carousel-previous", visible: :all)
  end

  # Loop, 5 slides, basis-1/3 (3 visible) — the "Sizes" docs example (default
  # options => loop: true). Next never disables in loop mode, so every click
  # must change the transform (no dead click) and the sequence must return to
  # the start (a wrap actually happened) within one lap.
  def test_loop_next_has_no_dead_clicks_and_wraps
    visit "/docs/carousel"
    section = demo("Sizes")

    start = track_transform(section)
    seen = [ start ]
    wrapped = false

    12.times do |i|
      next_button(section).click
      current = track_transform(section)
      refute_equal seen.last, current,
                   "click ##{i + 1} on Next was a dead click (transform unchanged)"
      wrapped = true if current == start
      seen << current
      break if wrapped
    end

    assert wrapped, "loop carousel never wrapped back to the start within a lap"
  end

  # Prev mirrors the wrap: from the start, one Prev jumps to the last reachable
  # offset (not blank space past it), and it must not be a dead click.
  def test_loop_prev_from_start_wraps_to_last_reachable
    visit "/docs/carousel"
    section = demo("Sizes")

    start = track_transform(section)
    prev_button(section).click
    after = track_transform(section)

    refute_equal start, after, "Prev from the start was a dead click"

    # One more Prev must also move (we're not stranded in the clamped zone).
    prev_button(section).click
    refute_equal after, track_transform(section),
                 "second Prev after the wrap was a dead click"
  end
end
