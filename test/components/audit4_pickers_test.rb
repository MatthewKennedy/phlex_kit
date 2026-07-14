# frozen_string_literal: true

require "test_helper"

# Audit round 4 fixes for the picker family (Select / Combobox / Command):
# roving tabindex on select options, root-level Escape, Home/End nav wiring,
# missing ARIA markup assertions, a real (aria-label + data-label) group label
# in the combobox instead of an invalid bare `label` attribute, the command
# item href="#" click guard, opt-in autofocus for inline command palettes, and
# per-instance command-dialog tracking replacing the page-global outlet.
class Audit4PickersTest < Minitest::Test
  include RenderHelper

  # --- Select ---

  # Listbox pattern: options rove with tabindex="-1" so Tab exits the widget;
  # the controller moves focus programmatically (focus() works on -1).
  def test_select_item_tabindex_is_minus_one
    html = render(PhlexKit::SelectItem.new(value: "admin") { "Admin" })
    assert_includes html, %(tabindex="-1")
    refute_includes html, %(tabindex="0")
  end

  # Escape must close the panel from anywhere in the widget (popover=manual
  # ignores light dismiss) — bound on the root so it works with focus on the
  # trigger, not only on an item.
  def test_select_root_binds_escape
    html = render(PhlexKit::Select.new)
    assert_includes html, "keydown.esc->phlex-kit--select#handleEsc"
  end

  def test_select_item_binds_home_and_end
    html = render(PhlexKit::SelectItem.new(value: "admin") { "Admin" })
    assert_includes html, "keydown.home->phlex-kit--select#handleHome"
    assert_includes html, "keydown.end->phlex-kit--select#handleEnd"
  end

  def test_select_trigger_renders_combobox_aria
    html = render(PhlexKit::SelectTrigger.new)
    assert_includes html, %(aria-expanded="false")
    assert_includes html, %(aria-haspopup="listbox")
  end

  def test_select_content_is_a_listbox
    html = render(PhlexKit::SelectContent.new)
    assert_includes html, %(role="listbox")
    assert_includes html, %(popover="manual")
  end

  # --- Combobox ---

  # `label` is not a valid attribute on <div>; the group label must be exposed
  # to AT via aria-label and to the CSS ::before via data-label.
  def test_combobox_list_group_label_renders_aria_label_and_data_label
    html = render(PhlexKit::ComboboxListGroup.new(label: "Fruits"))
    assert_includes html, %(aria-label="Fruits")
    assert_includes html, %(data-label="Fruits")
    refute_includes html, %(<div label=)
  end

  def test_combobox_list_group_without_label_renders_no_label_attrs
    html = render(PhlexKit::ComboboxListGroup.new)
    refute_includes html, "aria-label"
    refute_includes html, "data-label"
  end

  # --- Command ---

  # Items default href="#"; the controller's click guard must be wired so
  # neither a mouse click nor the Enter-synthesized click() navigates to #.
  def test_command_item_wires_the_click_guard
    html = render(PhlexKit::CommandItem.new(value: "settings") { "Settings" })
    assert_includes html, "click->phlex-kit--command#onItemClick"
    assert_includes html, %(href="#")
  end

  # Inline palettes must not steal page focus on load; the dialog clone gets
  # focus from the command controller's connect() instead.
  def test_command_input_autofocus_defaults_off
    html = render(PhlexKit::CommandInput.new)
    refute_includes html, "autofocus"
  end

  def test_command_input_autofocus_is_opt_in
    html = render(PhlexKit::CommandInput.new(autofocus: true))
    assert_includes html, "autofocus"
  end

  # The document-scoped outlet selector let one dialog adopt another's open
  # palette; the controller now tracks its own clone (sheet pattern), so no
  # outlet attribute is rendered at all.
  def test_command_dialog_renders_no_global_outlet_selector
    html = render(PhlexKit::CommandDialog.new)
    refute_includes html, "outlet"
    assert_includes html, %(data-controller="phlex-kit--command-dialog")
  end

  # The clone marker stays: the command controller uses it to distinguish the
  # dialog clone (dismiss removes) from an inline palette (dismiss resets).
  def test_command_dialog_content_keeps_the_instance_marker
    html = render(PhlexKit::CommandDialogContent.new)
    assert_includes html, "data-phlex-kit--command-dialog-instance"
  end
end
