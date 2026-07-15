# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 6, phase 4: components with physical-direction math must work
# under dir="rtl" (only sidebar's pinning and resizable's drag math are
# documented exemptions). Cuprite is Chromium, which mirrors layout in RTL,
# so the geometry is directly observable.
class Audit6RtlSystemTest < SystemTestCase
  include InteractionHelpers

  def force_rtl
    page.execute_script(%(document.documentElement.dir = "rtl"))
  end

  def track_translate_x(section)
    section.evaluate_script(<<~JS)
      (() => {
        const track = this.querySelector("[data-phlex-kit--carousel-target='viewport']").firstElementChild;
        const m = new DOMMatrixReadOnly(getComputedStyle(track).transform);
        return m.m41;
      })()
    JS
  end

  def test_carousel_next_button_advances_in_rtl
    visit "/docs/carousel"
    force_rtl
    section = demo("Default")
    assert_in_delta 0, track_translate_x(section), 1

    section.find("button.pk-carousel-next", visible: :all).click
    x = track_translate_x(section)
    assert x > 1, "Next never moved the track in RTL (translate stuck at #{x}px)"
  end

  def test_carousel_arrow_keys_follow_physical_direction_in_rtl
    visit "/docs/carousel"
    force_rtl
    section = demo("Default")
    # Keyboard actions live on the carousel root; focus must be inside it —
    # the nav buttons are its focusable elements.
    button = section.find("button.pk-carousel-next", visible: :all)
    page.execute_script("arguments[0].focus()", button)

    # In RTL the next slide sits to the physical LEFT — ArrowLeft advances.
    press(:left)
    x = track_translate_x(section)
    assert x > 1, "ArrowLeft did not advance the RTL carousel (translate #{x}px)"

    # ...and ArrowRight returns toward the first slide.
    press(:right)
    assert_in_delta 0, track_translate_x(section), 1
  end

  def test_switch_checked_thumb_stays_inside_track_in_rtl
    visit "/docs/switch"
    force_rtl
    section = demo("Default")
    section.find(".pk-switch", match: :first).click

    within_track = section.evaluate_script(<<~JS)
      (() => {
        const track = this.querySelector(".pk-switch");
        const thumb = track.querySelector(".pk-switch-thumb");
        const t = track.getBoundingClientRect(), h = thumb.getBoundingClientRect();
        return h.left >= t.left - 0.5 && h.right <= t.right + 0.5;
      })()
    JS
    assert within_track, "checked switch thumb slid outside its track in RTL"
  end
end
