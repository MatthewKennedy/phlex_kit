# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 7, task 9 — non-loop multi-up carousel bound state + Firefox image-drag
# suppression. carousel_controller.js's _offsetOf clamps every offset to
# _maxOffset() (track − viewport); with a basis-1/3 layout the track hits
# that max before this.index reaches the last slide, so an index-based
# canNext left Next enabled for several dead clicks. Fix is offset-based.
class Audit7CarouselSystemTest < SystemTestCase
  include InteractionHelpers

  def track_transform(section)
    section.evaluate_script(<<~JS)
      this.querySelector("[data-phlex-kit--carousel-target='viewport']").firstElementChild.style.transform
    JS
  end

  def next_button(section)
    section.find("button.pk-carousel-next", visible: :all)
  end

  # Non-loop, 5 slides, basis-1/3 viewport (3 visible at once) — the "No
  # Loop" docs example. Clicking Next must disable the button exactly when
  # the track reaches its max scrollable offset, and every enabled click
  # must actually move the track (no dead clicks).
  def test_next_disables_exactly_at_max_offset_with_no_dead_clicks
    visit "/docs/carousel"
    section = demo("No Loop")

    seen_transforms = [ track_transform(section) ]
    click_count = 0

    20.times do
      button = next_button(section)
      break if button.disabled?

      button.click
      click_count += 1
      new_transform = track_transform(section)
      refute_equal seen_transforms.last, new_transform,
                   "click ##{click_count} on Next was a dead click (transform unchanged)"
      seen_transforms << new_transform
    end

    assert next_button(section).disabled?, "Next never disabled after repeated clicks"
    assert click_count.positive?, "Next was disabled from the start — test fixture didn't exercise the bug"

    # The track must not be able to scroll any further: one more logical
    # step (via ArrowRight) must be a no-op.
    button = next_button(section)
    page.execute_script("arguments[0].focus()", button)
    before = track_transform(section)
    press(:right)
    assert_equal before, track_transform(section),
                 "ArrowRight moved the track past the max offset bound"
  end

  # Firefox has no CSS equivalent of -webkit-user-drag: none, so a pointer
  # drag starting on an <img> slide fires a native dragstart there — the
  # controller must preventDefault it directly, but NOT on non-img children
  # to allow dragging links and text selection.
  def test_dragstart_on_img_is_prevented_but_not_on_other_children
    visit "/docs/carousel"
    section = demo("Default")
    viewport = section.find("[data-phlex-kit--carousel-target='viewport']", visible: :all)

    # Add a test img to the carousel (carousel content may not have one by default)
    page.execute_script(<<~JS, viewport)
      const img = document.createElement("img");
      img.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==";
      arguments[0].querySelector(".pk-carousel-track").firstElementChild.appendChild(img);
    JS

    # dragstart on an img should be prevented (the Firefox fix)
    img_prevented = page.evaluate_script(<<~JS, viewport)
      (() => {
        const img = arguments[0].querySelector("img");
        const event = new Event("dragstart", { bubbles: true, cancelable: true });
        img?.dispatchEvent(event);
        return event.defaultPrevented;
      })()
    JS

    assert img_prevented, "dragstart on an img inside the carousel was not prevented (Firefox fix broken)"

    # dragstart on a non-img child (e.g., a slide div) should NOT be prevented
    div_prevented = page.evaluate_script(<<~JS, viewport)
      (() => {
        const slide = arguments[0].querySelector(".pk-carousel-track").firstElementChild;
        const event = new Event("dragstart", { bubbles: true, cancelable: true });
        slide?.dispatchEvent(event);
        return event.defaultPrevented;
      })()
    JS

    refute div_prevented, "dragstart on a non-img child was prevented (blocks link dragging or text selection)"
  end
end
