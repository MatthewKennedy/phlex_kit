# frozen_string_literal: true

require "test_helper"

# shadcn/ui components beyond the ruby_ui catalog (tier 1 — CSS-only).
class ShadcnAdditionsTest < Minitest::Test
  include RenderHelper

  def test_spinner_sizes_fail_loud
    assert_includes render(PhlexKit::Spinner.new), "pk-spinner"
    assert_includes render(PhlexKit::Spinner.new(size: :lg)), "pk-spinner lg"
    assert_includes render(PhlexKit::Spinner.new), %(aria-label="Loading")
    assert_raises(KeyError) { render(PhlexKit::Spinner.new(size: :xxl)) }
  end

  def test_kbd_and_group
    assert_includes render(PhlexKit::Kbd.new { "K" }), "<kbd"
    assert_includes render(PhlexKit::KbdGroup.new { "x" }), "pk-kbd-group"
  end

  def test_label_binds
    html = render(PhlexKit::Label.new(for: "email") { "Email" })
    assert_includes html, %(for="email")
    assert_includes html, "pk-label"
  end

  def test_button_group_is_a_group
    assert_includes render(PhlexKit::ButtonGroup.new { "x" }), %(role="group")
  end

  def test_item_family
    html = render(PhlexKit::Item.new(variant: :outline) { "x" })
    assert_includes html, "pk-item outline"
    assert_raises(KeyError) { render(PhlexKit::Item.new(variant: :bad) { "x" }) }
    assert_includes render(PhlexKit::ItemContent.new { "x" }), "pk-item-content"
    assert_includes render(PhlexKit::ItemGroup.new { "x" }), %(role="list")
  end

  def test_input_group_addon_aligns
    assert_includes render(PhlexKit::InputGroup.new { "x" }), %(role="group")
    assert_includes render(PhlexKit::InputGroupAddon.new(align: :end) { "x" }), "pk-input-group-addon end"
    assert_raises(KeyError) { render(PhlexKit::InputGroupAddon.new(align: :middle) { "x" }) }
    assert_includes render(PhlexKit::InputGroupText.new { "@" }), "pk-input-group-text"
  end

  def test_radio_group_role
    assert_includes render(PhlexKit::RadioGroup.new { "x" }), %(role="radiogroup")
  end

  def test_scroll_area_is_focusable
    html = render(PhlexKit::ScrollArea.new { "x" })
    assert_includes html, "pk-scroll-area"
    assert_includes html, %(tabindex="0")
  end

  def test_slider_syncs_progress
    html = render(PhlexKit::Slider.new(min: 0, max: 200, value: 50, name: "volume"))
    assert_includes html, %(type="range")
    assert_includes html, "--pk-slider-progress: 25.0%"
    assert_includes html, "input->phlex-kit--slider#update"
  end

  def test_input_otp_wires_slots_and_hidden_value
    html = render(PhlexKit::InputOtp.new(length: 4, name: "code"))
    assert_includes html, %(data-phlex-kit--input-otp-length-value="4")
    assert_includes html, %(type="hidden")
    assert_includes render(PhlexKit::InputOtpGroup.new { "x" }), "pk-input-otp-group"
    slot = render(PhlexKit::InputOtpSlot.new)
    assert_includes slot, %(autocomplete="one-time-code")
    assert_includes slot, %(maxlength="1")
    assert_includes slot, "paste->phlex-kit--input-otp#onPaste"
  end

  def test_drawer_reuses_sheet_machinery
    html = render(PhlexKit::Drawer.new { "x" })
    assert_includes html, "phlex-kit--sheet"
    content = render(PhlexKit::DrawerContent.new { "body" })
    assert_includes content, "<template"
    assert_includes content, "pk-drawer-handle"
    assert_includes content, "click->phlex-kit--sheet-content#close"
    assert_includes content, %(role="dialog")
    assert_includes render(PhlexKit::DrawerTrigger.new { "t" }), "click->phlex-kit--sheet#open"
  end
end
