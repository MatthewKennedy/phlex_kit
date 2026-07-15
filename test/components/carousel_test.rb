# frozen_string_literal: true

require "test_helper"

# Carousel — ported from ruby_ui (embla-carousel replaced by the translate-based
# phlex-kit--carousel controller).
class CarouselTest < Minitest::Test
  include RenderHelper

  def test_carousel_wires_controller_and_orientation
    html = render(PhlexKit::Carousel.new { "x" })
    assert_includes html, "phlex-kit--carousel"
    assert_includes html, "pk-carousel is-horizontal"
    assert_includes html, %(aria-roledescription="carousel")
    assert_includes html, "keydown.right->phlex-kit--carousel#keyNext:prevent"
    assert_includes html, "&quot;axis&quot;:&quot;x&quot;"
  end

  def test_vertical_orientation_sets_y_axis
    html = render(PhlexKit::Carousel.new(orientation: :vertical) { "x" })
    assert_includes html, "is-vertical"
    assert_includes html, "&quot;axis&quot;:&quot;y&quot;"
  end

  def test_orientation_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Carousel.new(orientation: :diagonal) { "x" }) }
  end

  def test_content_renders_viewport_and_track
    html = render(PhlexKit::CarouselContent.new { "x" })
    assert_includes html, %(data-phlex-kit--carousel-target="viewport")
    assert_includes html, "pk-carousel-track"
  end

  def test_item_is_a_slide_group
    html = render(PhlexKit::CarouselItem.new { "x" })
    assert_includes html, %(aria-roledescription="slide")
    assert_includes html, "pk-carousel-item"
  end

  def test_previous_and_next_buttons_wired_and_disabled
    prev = render(PhlexKit::CarouselPrevious.new)
    assert_includes prev, "click->phlex-kit--carousel#scrollPrev"
    assert_includes prev, %(data-phlex-kit--carousel-target="prevButton")
    assert_includes prev, "disabled"
    assert_includes prev, "Previous slide"
    nxt = render(PhlexKit::CarouselNext.new)
    assert_includes nxt, "click->phlex-kit--carousel#scrollNext"
    assert_includes nxt, "pk-button outline icon pk-carousel-next"
  end
end
