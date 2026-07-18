# frozen_string_literal: true

require "test_helper"

# Audit round 9: unit coverage for the confirmed discovery-audit fixes —
# mix-fusion guards on generated attrs, aria boolean serialization, Symbol
# type: defaults, and the toggle_group form/tab-stop defects.
class Audit9ConfirmedFixesTest < Minitest::Test
  include RenderHelper

  # --- generated aria-labels yield to the caller's ---------------------------

  LABELED = {
    PhlexKit::Breadcrumb => "breadcrumb",
    PhlexKit::CalendarNext => "Go to next month",
    PhlexKit::CalendarPrev => "Go to previous month",
    PhlexKit::ComboboxClearButton => "Clear selection",
    PhlexKit::DataTableSelectAllCheckbox => "Select all",
    PhlexKit::SidebarTrigger => "Toggle sidebar"
  }.freeze

  def test_generated_aria_labels_default_and_yield_to_caller
    LABELED.each do |klass, default|
      assert_includes render(klass.new), %(aria-label="#{default}"), klass.name
      html = render(klass.new(aria: { label: "Localized" }))
      assert_includes html, %(aria-label="Localized"), klass.name
      refute_includes html, %(aria-label="#{default}),
        "#{klass.name} default must not fuse with the caller label"
    end
  end

  def test_sidebar_rail_title_and_label_yield_to_caller
    html = render(PhlexKit::SidebarRail.new(title: "Umschalten", aria: { label: "Umschalten" }))
    assert_equal 1, html.scan("title=").length
    refute_includes html, "Toggle sidebar"
  end

  # --- generated roles yield to the caller's ---------------------------------

  def test_generated_roles_yield_to_caller
    html = render(PhlexKit::Alert.new(role: "status") { "x" })
    assert_includes html, %(role="status")
    refute_includes html, %(role="alert)
    assert_includes render(PhlexKit::FieldError.new(errors: [ "bad" ], role: "status")), %(role="status")
    html = render(PhlexKit::Switch.new(role: "checkbox"))
    assert_includes html, %(role="checkbox")
    refute_includes html, %(role="switch)
  end

  def test_command_dialog_panel_guards_role_and_modal
    html = render(PhlexKit::CommandDialogContent.new(role: "alertdialog") { "x" })
    assert_includes html, %(role="alertdialog")
    refute_includes html, %(role="dialog alertdialog")
    html = render(PhlexKit::CommandDialogContent.new(aria: { modal: "false" }) { "x" })
    refute_includes html, %(aria-modal="true false")
  end

  def test_resizable_handle_guards_role_tabindex_orientation
    html = render(PhlexKit::ResizableHandle.new(role: "slider", tabindex: "-1", aria: { orientation: "horizontal" }))
    assert_includes html, %(role="slider")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(aria-orientation="horizontal")
    refute_includes html, "separator"
  end

  def test_carousel_roledescription_yields_to_caller
    html = render(PhlexKit::CarouselItem.new(aria: { roledescription: "Folie" }) { "x" })
    assert_includes html, %(aria-roledescription="Folie")
    refute_includes html, "slide"
  end

  def test_dropdown_separator_orientation_guard_covers_aria_hash_spelling
    html = render(PhlexKit::DropdownMenuSeparator.new(aria: { orientation: "vertical" }))
    assert_includes html, %(aria-orientation="vertical")
    refute_includes html, "horizontal"
  end

  def test_tabs_trigger_aria_controls_yields_to_caller
    html = render(PhlexKit::TabsTrigger.new(value: "a", aria: { controls: "custom-panel" }) { "Tab" })
    assert_includes html, %(aria-controls="custom-panel")
    refute_includes html, "pk-tabs-panel-a"
  end

  def test_input_otp_slot_input_attrs_yield_to_caller
    html = render(PhlexKit::InputOtpSlot.new(inputmode: "text", autocomplete: "off"))
    assert_includes html, %(inputmode="text")
    assert_includes html, %(autocomplete="off")
    refute_includes html, "numeric"
    refute_includes html, "one-time-code"
  end

  # --- type: defaults are Symbols (mix override, not fusion) -----------------

  def test_button_type_defaults_are_overridable
    html = render(PhlexKit::SidebarGroupAction.new(type: "submit") { "x" })
    assert_includes html, %(type="submit")
    refute_includes html, %(type="button submit")
    html = render(PhlexKit::Toggle.new(type: "submit") { "x" })
    assert_includes html, %(type="submit")
    refute_includes html, "button submit"
  end

  # --- aria booleans serialize as the string spelling ------------------------

  def test_separator_aria_hidden_is_a_real_true_value
    [ PhlexKit::BreadcrumbSeparator.new, PhlexKit::ButtonGroupSeparator.new,
      PhlexKit::ItemSeparator.new, PhlexKit::SelectSeparator.new ].each do |c|
      assert_includes render(c), %(aria-hidden="true"), c.class.name
    end
  end

  def test_breadcrumb_page_aria_disabled_is_a_real_true_value
    assert_includes render(PhlexKit::BreadcrumbPage.new { "Here" }), %(aria-disabled="true")
  end

  # --- interactive bubble is not an implicit submit --------------------------

  def test_bubble_content_button_defaults_type_button
    assert_includes render(PhlexKit::BubbleContent.new(as: :button) { "x" }), %(type="button")
    assert_includes render(PhlexKit::BubbleContent.new(as: :button, type: "submit") { "x" }), %(type="submit")
    refute_includes render(PhlexKit::BubbleContent.new { "x" }), "type="
  end

  # --- toggle_group form + tab-stop defects ----------------------------------

  def test_disabled_toggle_group_does_not_submit_hidden_inputs
    html = render(PhlexKit::ToggleGroup.new(type: :single, name: "align", value: "left", disabled: true) { |g|
      g.ToggleGroupItem(value: "left") { "L" }
    })
    assert_match(/<input type="hidden" name="align" value="left" disabled/, html)
    enabled = render(PhlexKit::ToggleGroup.new(type: :single, name: "align", value: "left") { |g|
      g.ToggleGroupItem(value: "left") { "L" }
    })
    refute_match(/type="hidden"[^>]*disabled/, enabled)
  end

  def test_toggle_group_with_disabled_selection_still_has_a_tab_stop
    html = render(PhlexKit::ToggleGroup.new(type: :single, name: "align", value: "left") { |g|
      g.ToggleGroupItem(value: "left", disabled: true) { "L" }
      g.ToggleGroupItem(value: "center") { "C" }
    })
    tabindexes = html.scan(/tabindex="(-?\d)"/).flatten
    assert_equal [ "-1", "0" ], tabindexes,
      "an enabled item after the pressed-but-disabled one must claim the tab stop"
  end
end
