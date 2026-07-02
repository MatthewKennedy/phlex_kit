# frozen_string_literal: true

require "test_helper"

# Typography — heading size classes must match the CSS (.pk-heading-N); the
# ui-heading-N leftover from the revue transform made sizes a no-op.
class TypographyTest < Minitest::Test
  include RenderHelper

  def test_heading_size_class_matches_css
    html = render(PhlexKit::Heading.new(level: 1) { "H1" })
    assert_includes html, "pk-heading pk-heading-7"
    refute_includes html, "ui-heading"
    assert_includes render(PhlexKit::Heading.new(size: 4) { "x" }), "pk-heading-4"
  end

  def test_text_styles_cover_shadcn_prose_set
    assert_includes render(PhlexKit::Text.new(size: :xl, weight: :muted) { "Lead" }), "pk-text-5"
    assert_includes render(PhlexKit::Text.new(size: :lg, weight: :semibold) { "Large" }), "pk-text-semibold"
    assert_includes render(PhlexKit::Text.new(size: :sm, weight: :muted) { "Muted" }), "pk-text-muted"
  end
end
