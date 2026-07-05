# frozen_string_literal: true

require "test_helper"

class BadgeTest < Minitest::Test
  include RenderHelper

  def test_default_variant_and_base_class
    html = render(PhlexKit::Badge.new { "New" })
    assert_includes html, "pk-badge"
    assert_includes html, "primary"
    assert_includes html, "New"
  end

  def test_variant_and_size_modifiers
    html = render(PhlexKit::Badge.new(variant: :success, size: :lg) { "OK" })
    assert_includes html, "success"
    assert_includes html, "lg"
  end

  def test_unknown_variant_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Badge.new(variant: :nope) { "x" }) }
  end

  def test_ghost_and_link_variants
    assert_includes render(PhlexKit::Badge.new(variant: :ghost) { "x" }), "ghost"
    assert_includes render(PhlexKit::Badge.new(variant: :link) { "x" }), "link"
  end

  def test_href_renders_an_anchor
    html = render(PhlexKit::Badge.new(href: "/inbox") { "Inbox" })
    assert_includes html, "<a"
    assert_includes html, %(href="/inbox")
    assert_includes html, "pk-badge"
  end

  def test_caller_class_is_merged_not_clobbered
    html = render(PhlexKit::Badge.new(class: "extra") { "x" })
    assert_includes html, "pk-badge"
    assert_includes html, "extra"
  end
end
