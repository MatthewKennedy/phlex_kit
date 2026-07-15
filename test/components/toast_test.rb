# frozen_string_literal: true

require "test_helper"

# Toast — sonner-style toaster ported from ruby_ui (region + item + parts,
# template skeletons cloned client-side by phlex-kit--toaster).
class ToastTest < Minitest::Test
  include RenderHelper

  def test_region_wires_toaster_controller_and_position
    html = render(PhlexKit::ToastRegion.new)
    assert_includes html, "phlex-kit--toaster"
    assert_includes html, %(data-position="bottom-right")
    assert_includes html, %(data-phlex-kit--toaster-hotkey-value="alt+t")
    assert_includes html, %(aria-label="Notifications")
  end

  def test_region_renders_a_skeleton_template_per_variant
    html = render(PhlexKit::ToastRegion.new)
    PhlexKit::ToastRegion::SKELETON_VARIANTS.each do |variant|
      assert_includes html, %(data-variant="#{variant}")
    end
    assert_includes html, %(data-phlex-kit--toaster-target="skeleton")
    assert_includes html, %(data-phlex-kit--toaster-target="actionTpl")
  end

  def test_region_position_fails_loud
    assert_raises(KeyError) { render(PhlexKit::ToastRegion.new(position: :middle)) }
  end

  def test_region_renders_flash_as_toast_items
    html = render(PhlexKit::ToastRegion.new(flash: { "notice" => "Saved" }))
    assert_includes html, %(id="flash-notice")
    assert_includes html, "Saved"
    assert_includes html, %(data-variant="info")
  end

  def test_item_role_and_wiring
    html = render(PhlexKit::ToastItem.new(variant: :error, duration: 9000) { "x" })
    assert_includes html, %(role="alert")
    assert_includes html, "pk-toast"
    assert_includes html, %(data-phlex-kit--toaster-target="toast")
    assert_includes html, %(data-phlex-kit--toast-duration-value="9000")
    assert_includes render(PhlexKit::ToastItem.new { "x" }), %(role="status")
  end

  def test_item_variant_fails_loud
    assert_raises(KeyError) { render(PhlexKit::ToastItem.new(variant: :nope) { "x" }) }
  end

  def test_icon_renders_only_for_status_variants
    assert_includes render(PhlexKit::ToastIcon.new(variant: :success)), %(data-slot="icon")
    assert_includes render(PhlexKit::ToastIcon.new(variant: :loading)), "spin"
    assert_equal "", render(PhlexKit::ToastIcon.new(variant: :default))
  end

  def test_parts_carry_slots_and_dismiss_actions
    assert_includes render(PhlexKit::ToastTitle.new { "T" }), %(data-slot="title")
    assert_includes render(PhlexKit::ToastDescription.new { "D" }), %(data-slot="description")
    assert_includes render(PhlexKit::ToastAction.new(label: "Undo", on: "click->x#y")), %(data-action="click->x#y click->phlex-kit--toast#dismiss")
    assert_includes render(PhlexKit::ToastCancel.new(label: "Cancel")), "click->phlex-kit--toast#dismiss"
    assert_includes render(PhlexKit::ToastClose.new), "pk-sr-only"
  end

  def test_flash_variant_mapping
    assert_equal :info, PhlexKit::Toast.flash_variant(:notice)
    assert_equal :default, PhlexKit::Toast.flash_variant(:whatever)
  end

  # ToastRegion(duration:) must reach the toasts: flash items and the cloned
  # skeletons both fall back to the toast controller's 4000ms default unless
  # the region's duration is stamped on them at render time.
  def test_region_duration_reaches_flash_toasts
    html = render(PhlexKit::ToastRegion.new(duration: 10_000, flash: { notice: "Saved" }))
    assert_includes html, %(id="flash-notice")
    assert_includes html, %(data-phlex-kit--toast-duration-value="10000")
  end

  def test_region_duration_reaches_skeleton_templates
    html = render(PhlexKit::ToastRegion.new(duration: 10_000))
    assert_equal PhlexKit::ToastRegion::SKELETON_VARIANTS.length,
                 html.scan(%(data-phlex-kit--toast-duration-value="10000")).length
  end
end
