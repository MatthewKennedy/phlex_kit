# frozen_string_literal: true

require "test_helper"

# Audit round 4 — toast family markup fixes (region ids, flash close button,
# nested live regions). JS-side findings are covered by node --check + browser
# validation, not here.
class Audit4ToastFamilyTest < Minitest::Test
  include RenderHelper

  # Finding 5: two regions on one page must not collide on hardcoded ids.
  def test_region_default_ids_are_unchanged
    html = render(PhlexKit::ToastRegion.new)
    assert_includes html, %(id="pk-toaster-region")
    assert_includes html, %(id="pk-toaster")
  end

  def test_region_accepts_a_custom_id
    html = render(PhlexKit::ToastRegion.new(id: "pk-toaster-2"))
    assert_includes html, %(id="pk-toaster-2-region")
    assert_includes html, %(id="pk-toaster-2")
    refute_includes html, %(id="pk-toaster-region")
    refute_includes html, %(id="pk-toaster")
  end

  # Finding 6: flash toasts must get the corner close button when the region
  # has close_button: true (CSS already reserves the padding for it).
  def test_flash_toasts_render_close_button_when_region_has_close_button
    base = render(PhlexKit::ToastRegion.new(close_button: true))
    with_flash = render(PhlexKit::ToastRegion.new(close_button: true, flash: { notice: "Saved" }))
    assert_equal base.scan("pk-toast-close").length + 1,
                 with_flash.scan("pk-toast-close").length
  end

  def test_flash_toasts_render_no_close_button_without_region_close_button
    base = render(PhlexKit::ToastRegion.new)
    with_flash = render(PhlexKit::ToastRegion.new(flash: { notice: "Saved" }))
    assert_equal base.scan("pk-toast-close").length,
                 with_flash.scan("pk-toast-close").length
  end

  # Finding 7: items are live regions themselves (role=status/alert); the
  # wrapper must not also be aria-live or screen readers double-announce.
  def test_region_wrapper_is_not_itself_a_live_region
    html = render(PhlexKit::ToastRegion.new(flash: { notice: "Saved" }))
    refute_includes html, "aria-live"
    assert_includes html, %(aria-label="Notifications")
    assert_includes html, %(role="status")
  end
end
