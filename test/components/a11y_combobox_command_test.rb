# frozen_string_literal: true

require "test_helper"

# ARIA 1.2 combobox-pattern audit fixes for Combobox and Command: the combobox
# role sits on the interactive element (not a wrapper), the listbox parts carry
# role + id for aria-controls, options are non-tab-stop composites, filtered
# result counts are announced via an sr-only live region, and the command
# dialog clone is a proper modal dialog.
class A11yComboboxCommandTest < Minitest::Test
  include RenderHelper

  # --- Combobox ---

  def test_combobox_wrapper_has_no_combobox_role_but_renders_live_region
    html = render(PhlexKit::Combobox.new(term: "tags") { "x" })
    refute_includes html, %(role="combobox")
    assert_includes html, "pk-sr-only"
    assert_includes html, %(aria-live="polite")
    assert_includes html, %(data-phlex-kit--combobox-target="liveRegion")
  end

  def test_combobox_list_is_an_identified_listbox
    html = render(PhlexKit::ComboboxList.new { "x" })
    assert_includes html, %(role="listbox")
    assert_includes html, %(id="pk-combobox-list-)
    assert_includes html, %(data-phlex-kit--combobox-target="list")
  end

  def test_combobox_trigger_button_keeps_expanded_and_haspopup
    html = render(PhlexKit::ComboboxTrigger.new(placeholder: "Pick one"))
    assert_includes html, %(aria-haspopup="listbox")
    assert_includes html, %(aria-expanded="false")
    refute_includes html, %(role="combobox")
  end

  def test_combobox_search_input_is_the_combobox
    html = render(PhlexKit::ComboboxSearchInput.new(placeholder: "Search…", list_id: "cb-list"))
    assert_includes html, %(role="combobox")
    assert_includes html, %(aria-autocomplete="list")
    assert_includes html, %(aria-expanded="false")
    assert_includes html, %(aria-controls="cb-list")
  end

  def test_combobox_input_trigger_field_is_the_combobox
    html = render(PhlexKit::ComboboxInputTrigger.new(placeholder: "Pick", list_id: "cb-list"))
    assert_includes html, %(role="combobox")
    assert_includes html, %(aria-haspopup="listbox")
    assert_includes html, %(aria-autocomplete="list")
    assert_includes html, %(aria-controls="cb-list")
    # the wrapper div no longer claims expanded state
    refute_includes html, %(class="pk-combobox-input-trigger" aria-expanded)
  end

  def test_combobox_badge_trigger_field_is_the_combobox
    html = render(PhlexKit::ComboboxBadgeTrigger.new(placeholder: "Add", list_id: "cb-list"))
    assert_includes html, %(role="combobox")
    assert_includes html, %(aria-autocomplete="list")
    assert_includes html, %(aria-controls="cb-list")
  end

  def test_combobox_item_renders_aria_selected_and_inputs_are_not_tab_stops
    assert_includes render(PhlexKit::ComboboxItem.new { "x" }), %(aria-selected="false")
    assert_includes render(PhlexKit::ComboboxCheckbox.new(name: "t[]", value: "a")), %(tabindex="-1")
    assert_includes render(PhlexKit::ComboboxRadio.new(name: "t", value: "a")), %(tabindex="-1")
  end

  # --- Command ---

  def test_command_root_renders_live_region
    html = render(PhlexKit::Command.new { "x" })
    assert_includes html, "pk-sr-only"
    assert_includes html, %(aria-live="polite")
    assert_includes html, %(data-phlex-kit--command-target="liveRegion")
  end

  def test_command_list_is_an_identified_listbox
    html = render(PhlexKit::CommandList.new { "x" })
    assert_includes html, %(role="listbox")
    assert_includes html, %(id="pk-command-list-)
    assert_includes html, %(data-phlex-kit--command-target="list")
  end

  def test_command_input_combobox_wiring
    html = render(PhlexKit::CommandInput.new(list_id: "cmd-list"))
    assert_includes html, %(role="combobox")
    assert_includes html, %(aria-autocomplete="list")
    assert_includes html, %(aria-expanded="true")
    assert_includes html, %(aria-controls="cmd-list")
  end

  def test_command_item_disabled_emission
    html = render(PhlexKit::CommandItem.new(value: "settings", disabled: true) { "Settings" })
    assert_includes html, %(data-disabled="true")
    assert_includes html, %(aria-disabled="true")

    enabled = render(PhlexKit::CommandItem.new(value: "settings") { "Settings" })
    refute_includes enabled, "data-disabled"
    refute_includes enabled, "aria-disabled"
  end

  def test_command_dialog_content_is_a_modal_dialog_with_focus_trap
    html = render(PhlexKit::CommandDialogContent.new { "x" })
    assert_includes html, %(role="dialog")
    assert_includes html, %(aria-modal="true")
    assert_includes html, %(aria-label="Command palette")
    assert_includes html, "keydown->phlex-kit--command#trapFocus"
  end
end
