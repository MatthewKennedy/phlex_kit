# frozen_string_literal: true

require "test_helper"

class AvatarTest < Minitest::Test
  include RenderHelper

  def test_default_size_and_controller
    html = render(PhlexKit::Avatar.new { "x" })
    assert_includes html, "pk-avatar"
    assert_includes html, "phlex-kit--avatar"
    refute_includes html, "pk-avatar sm"
  end

  def test_size_modifiers
    assert_includes render(PhlexKit::Avatar.new(size: :sm) { "x" }), "sm"
    assert_includes render(PhlexKit::Avatar.new(size: :lg) { "x" }), "lg"
  end

  def test_unknown_size_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Avatar.new(size: :nope) { "x" }) }
  end

  def test_image_targets_controller
    html = render(PhlexKit::AvatarImage.new(src: "/u.png", alt: "@u"))
    assert_includes html, "pk-avatar-image"
    assert_includes html, "phlex-kit--avatar#showImage"
  end

  def test_fallback
    html = render(PhlexKit::AvatarFallback.new { "CN" })
    assert_includes html, "pk-avatar-fallback"
    assert_includes html, "CN"
  end

  def test_badge
    html = render(PhlexKit::AvatarBadge.new)
    assert_includes html, "pk-avatar-badge"
    assert_includes html, "<span"
  end

  def test_group_and_count
    assert_includes render(PhlexKit::AvatarGroup.new { "x" }), "pk-avatar-group"
    html = render(PhlexKit::AvatarGroupCount.new { "+3" })
    assert_includes html, "pk-avatar-group-count"
    assert_includes html, "+3"
  end

  def test_caller_class_is_merged_not_clobbered
    html = render(PhlexKit::Avatar.new(class: "extra") { "x" })
    assert_includes html, "pk-avatar"
    assert_includes html, "extra"
  end
end
