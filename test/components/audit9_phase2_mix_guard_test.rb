# frozen_string_literal: true

require "test_helper"

# Audit round 9, phase 2 — the remaining unguarded generated defaults. Same
# contract as audit7_mix_fusion_test: a caller override must win cleanly (no
# fused "a b" value) and the generated default must still render when the
# caller supplies nothing. Covers the guard sweep across the menu families
# (content/sub_content/group/separator/item/checkbox/radio parts), the
# stragglers (accordion/tabs/select/combobox/field/icon/alert_dialog_media),
# and the checkbox hidden-input form: ride-along.
class Audit9Phase2MixGuardTest < Minitest::Test
  include RenderHelper

  # -- accordion_content ---------------------------------------------------

  def test_accordion_content_default_role
    html = render(PhlexKit::AccordionContent.new { "body" })
    assert_includes html, %(role="region")
  end

  def test_accordion_content_caller_role_overrides_cleanly
    html = render(PhlexKit::AccordionContent.new(role: "none") { "body" })
    assert_includes html, %(role="none")
    refute_includes html, "region none"
  end

  # -- alert_dialog_media ----------------------------------------------------

  def test_alert_dialog_media_default_aria_hidden
    html = render(PhlexKit::AlertDialogMedia.new { "art" })
    assert_includes html, %(aria-hidden="true")
  end

  def test_alert_dialog_media_caller_aria_hidden_overrides_cleanly
    html = render(PhlexKit::AlertDialogMedia.new(aria: { hidden: "false" }) { "art" })
    assert_includes html, %(aria-hidden="false")
    refute_includes html, "true false"
  end

  # -- checkbox hidden input rides form: -------------------------------------

  def test_checkbox_hidden_input_copies_form
    html = render(PhlexKit::Checkbox.new(name: "opt", form: "settings"))
    assert_includes html, %(type="hidden")
    assert_equal 2, html.scan(%(form="settings")).count
  end

  def test_checkbox_hidden_input_without_form
    html = render(PhlexKit::Checkbox.new(name: "opt"))
    assert_includes html, %(type="hidden")
    refute_includes html, "form="
  end

  # -- combobox_item ---------------------------------------------------------

  def test_combobox_item_defaults
    html = render(PhlexKit::ComboboxItem.new { "One" })
    assert_includes html, %(role="option")
    assert_includes html, %(aria-selected="false")
  end

  def test_combobox_item_caller_aria_selected_overrides_cleanly
    html = render(PhlexKit::ComboboxItem.new(aria: { selected: "true" }) { "One" })
    assert_includes html, %(aria-selected="true")
    refute_includes html, "false true"
  end

  # -- field -----------------------------------------------------------------

  def test_field_caller_role_overrides_cleanly
    html = render(PhlexKit::Field.new(role: "radiogroup") { "f" })
    assert_includes html, %(role="radiogroup")
    refute_includes html, "group radiogroup"
  end

  # -- icon aria-hidden vs caller accessible name ------------------------------

  def test_icon_default_aria_hidden
    html = render(PhlexKit::Icon.new(:check))
    assert_includes html, %(aria-hidden="true")
  end

  def test_icon_caller_label_suppresses_aria_hidden_hash_spelling
    html = render(PhlexKit::Icon.new(:check, aria: { label: "Done" }))
    assert_includes html, %(aria-label="Done")
    refute_includes html, "aria-hidden"
  end

  def test_icon_caller_aria_hidden_hash_spelling_overrides_cleanly
    html = render(PhlexKit::Icon.new(:check, aria: { hidden: "false" }))
    assert_includes html, %(aria-hidden="false")
    refute_includes html, "true false"
  end

  # -- tabs_content ------------------------------------------------------------

  def test_tabs_content_defaults
    html = render(PhlexKit::TabsContent.new(value: "a") { "panel" })
    assert_includes html, %(aria-labelledby="pk-tabs-trigger-a")
    assert_includes html, %(tabindex="0")
  end

  def test_tabs_content_caller_labelledby_and_tabindex_override_cleanly
    html = render(PhlexKit::TabsContent.new(value: "a", tabindex: "-1", aria: { labelledby: "my-tab" }) { "panel" })
    assert_includes html, %(aria-labelledby="my-tab")
    assert_includes html, %(tabindex="-1")
    refute_includes html, "pk-tabs-trigger-a my-tab"
    refute_includes html, %(tabindex="0 -1")
  end

  # -- select_content ------------------------------------------------------------

  def test_select_content_defaults
    html = render(PhlexKit::SelectContent.new { "opts" })
    assert_includes html, %(role="listbox")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(popover="manual")
  end

  def test_select_content_caller_overrides_cleanly
    html = render(PhlexKit::SelectContent.new(role: "menu", tabindex: "0", popover: "auto") { "opts" })
    assert_includes html, %(role="menu")
    assert_includes html, %(tabindex="0")
    assert_includes html, %(popover="auto")
    refute_includes html, "listbox menu"
    refute_includes html, "manual auto"
  end

  # -- context_menu family ---------------------------------------------------

  def test_context_menu_content_defaults
    html = render(PhlexKit::ContextMenuContent.new { "rows" })
    assert_includes html, %(popover="manual")
    assert_includes html, %(role="menu")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(aria-orientation="vertical")
  end

  def test_context_menu_content_caller_overrides_cleanly
    html = render(PhlexKit::ContextMenuContent.new(role: "listbox", popover: "auto", aria: { orientation: "horizontal" }) { "rows" })
    assert_includes html, %(role="listbox")
    assert_includes html, %(popover="auto")
    assert_includes html, %(aria-orientation="horizontal")
    refute_includes html, "menu listbox"
    refute_includes html, "vertical horizontal"
  end

  def test_context_menu_item_caller_role_and_tabindex_override_cleanly
    html = render(PhlexKit::ContextMenuItem.new(role: "option", tabindex: "0") { "Row" })
    assert_includes html, %(role="option")
    assert_includes html, %(tabindex="0")
    refute_includes html, "menuitem option"
    refute_includes html, %(tabindex="-1 0")
  end

  def test_context_menu_checkbox_item_caller_aria_checked_overrides_cleanly
    html = render(PhlexKit::ContextMenuCheckboxItem.new(aria: { checked: "mixed" }) { "Row" })
    assert_includes html, %(aria-checked="mixed")
    refute_includes html, "false mixed"
  end

  def test_context_menu_separator_defaults
    html = render(PhlexKit::ContextMenuSeparator.new)
    assert_includes html, %(role="separator")
    assert_includes html, %(aria-orientation="horizontal")
  end

  def test_context_menu_sub_trigger_caller_aria_haspopup_overrides_cleanly
    html = render(PhlexKit::ContextMenuSubTrigger.new(aria: { haspopup: "listbox" }) { "More" })
    assert_includes html, %(aria-haspopup="listbox")
    refute_includes html, "menu listbox"
  end

  def test_context_menu_group_caller_role_overrides_cleanly
    html = render(PhlexKit::ContextMenuGroup.new(role: "none") { "rows" })
    assert_includes html, %(role="none")
    refute_includes html, "group none"
  end

  # -- dropdown_menu family ---------------------------------------------------

  def test_dropdown_menu_item_caller_role_and_tabindex_override_cleanly
    html = render(PhlexKit::DropdownMenuItem.new(role: "option", tabindex: "0") { "Row" })
    assert_includes html, %(role="option")
    assert_includes html, %(tabindex="0")
    refute_includes html, "menuitem option"
    refute_includes html, %(tabindex="-1 0")
  end

  def test_dropdown_menu_content_caller_role_overrides_cleanly
    html = render(PhlexKit::DropdownMenuContent.new(role: "listbox") { "rows" })
    assert_includes html, %(role="listbox")
    refute_includes html, "menu listbox"
  end

  def test_dropdown_menu_radio_group_caller_role_overrides_cleanly
    html = render(PhlexKit::DropdownMenuRadioGroup.new(role: "group") { "rows" })
    assert_includes html, %(role="group")
    refute_includes html, "radiogroup group"
  end

  def test_dropdown_menu_radio_item_caller_aria_checked_overrides_cleanly
    html = render(PhlexKit::DropdownMenuRadioItem.new(name: "n", value: "v", aria: { checked: "true" }) { "Row" })
    assert_includes html, %(aria-checked="true")
    refute_includes html, "false true"
  end

  def test_dropdown_menu_sub_trigger_defaults
    html = render(PhlexKit::DropdownMenuSubTrigger.new { "More" })
    assert_includes html, %(role="menuitem")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(aria-haspopup="menu")
    assert_includes html, %(aria-expanded="false")
  end

  # -- menubar family ---------------------------------------------------------

  def test_menubar_caller_role_overrides_cleanly
    html = render(PhlexKit::Menubar.new(role: "toolbar") { "menus" })
    assert_includes html, %(role="toolbar")
    refute_includes html, "menubar toolbar"
  end

  def test_menubar_trigger_caller_aria_expanded_overrides_cleanly
    html = render(PhlexKit::MenubarTrigger.new(aria: { expanded: "true" }) { "File" })
    assert_includes html, %(aria-expanded="true")
    refute_includes html, "false true"
  end

  def test_menubar_content_defaults
    html = render(PhlexKit::MenubarContent.new { "rows" })
    assert_includes html, %(popover="manual")
    assert_includes html, %(role="menu")
  end

  def test_menubar_item_caller_role_overrides_cleanly
    html = render(PhlexKit::MenubarItem.new(role: "option") { "Row" })
    assert_includes html, %(role="option")
    refute_includes html, "menuitem option"
  end

  def test_menubar_checkbox_item_caller_aria_checked_overrides_cleanly
    html = render(PhlexKit::MenubarCheckboxItem.new(aria: { checked: "mixed" }) { "Row" })
    assert_includes html, %(aria-checked="mixed")
    refute_includes html, "false mixed"
  end

  def test_menubar_separator_caller_role_overrides_cleanly
    html = render(PhlexKit::MenubarSeparator.new(role: "none"))
    assert_includes html, %(role="none")
    refute_includes html, "separator none"
  end

  def test_menubar_menu_default_role_none
    html = render(PhlexKit::MenubarMenu.new { "pair" })
    assert_includes html, %(role="none")
  end
end
