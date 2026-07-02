# frozen_string_literal: true

require "test_helper"

# Wave 1 — pure-style components ported from ruby_ui.
class Wave1Test < Minitest::Test
  include RenderHelper

  def test_skeleton
    assert_includes render(PhlexKit::Skeleton.new(class: "h-4")), "pk-skeleton"
  end

  def test_shortcut_key
    assert_includes render(PhlexKit::ShortcutKey.new { "K" }), "pk-shortcut-key"
  end

  def test_switch_emits_hidden_and_checkbox
    html = render(PhlexKit::Switch.new(name: "active"))
    assert_includes html, "pk-switch"
    assert_includes html, %(type="hidden")
    assert_includes html, %(type="checkbox")
  end

  def test_radio_button
    assert_includes render(PhlexKit::RadioButton.new(name: "r", value: "1")), %(type="radio")
  end

  def test_breadcrumb_compose
    html = render(PhlexKit::Breadcrumb.new do |b|
      b.render PhlexKit::BreadcrumbList.new {}
    end)
    assert_includes html, "pk-breadcrumb"
  end

  def test_bubble_variant_and_fail_loud
    assert_includes render(PhlexKit::Bubble.new(variant: :destructive) {}), %(data-variant="destructive")
    assert_raises(KeyError) { render(PhlexKit::Bubble.new(variant: :nope) {}) }
  end

  def test_empty_media_variant
    assert_includes render(PhlexKit::EmptyMedia.new(variant: :icon)), "icon"
  end

  def test_message_align
    assert_includes render(PhlexKit::Message.new(align: :end) {}), %(data-align="end")
  end
end
