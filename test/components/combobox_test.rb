# frozen_string_literal: true

require "test_helper"

# Combobox — searchable select ported from ruby_ui (CSS-positioned panel,
# form-submitting checkbox/radio inputs).
class ComboboxTest < Minitest::Test
  include RenderHelper

  def test_combobox_wires_controller_and_click_outside
    html = render(PhlexKit::Combobox.new(term: "tags") { "x" })
    assert_includes html, "phlex-kit--combobox"
    assert_includes html, %(data-phlex-kit--combobox-term-value="tags")
    assert_includes html, "click@window->phlex-kit--combobox#onClickOutside"
    assert_includes html, %(role="combobox")
  end

  def test_trigger_carries_placeholder_and_content_target
    html = render(PhlexKit::ComboboxTrigger.new(placeholder: "Pick one"))
    assert_includes html, %(data-placeholder="Pick one")
    assert_includes html, %(data-phlex-kit--combobox-target="triggerContent")
    assert_includes html, "phlex-kit--combobox#togglePopover"
    assert_includes html, %(aria-haspopup="listbox")
  end

  def test_popover_hidden_with_keyboard_nav
    html = render(PhlexKit::ComboboxPopover.new { "x" })
    assert_includes html, "pk-combobox-popover pk-hidden"
    assert_includes html, "keydown.down->phlex-kit--combobox#keyDownPressed"
    assert_includes html, "keydown.esc->phlex-kit--combobox#closePopover:prevent"
  end

  def test_search_input_filters
    html = render(PhlexKit::ComboboxSearchInput.new(placeholder: "Search…"))
    assert_includes html, %(role="searchbox")
    assert_includes html, "keyup->phlex-kit--combobox#filterItems"
  end

  def test_list_group_and_item_roles
    assert_includes render(PhlexKit::ComboboxList.new { "x" }), %(role="listbox")
    assert_includes render(PhlexKit::ComboboxListGroup.new(label: "Fruits") { "x" }), %(label="Fruits")
    html = render(PhlexKit::ComboboxItem.new { "x" })
    assert_includes html, %(role="option")
    assert_includes html, %(data-phlex-kit--combobox-target="item")
  end

  def test_checkbox_radio_and_toggle_all_wiring
    assert_includes render(PhlexKit::ComboboxCheckbox.new(name: "tags[]", value: "a")), "phlex-kit--combobox#inputChanged"
    radio = render(PhlexKit::ComboboxRadio.new(name: "tag", value: "a"))
    assert_includes radio, %(type="radio")
    assert_includes radio, "invalid->phlex-kit--form-field#onInvalid"
    assert_includes render(PhlexKit::ComboboxToggleAllCheckbox.new), "change->phlex-kit--combobox#toggleAllItems"
  end

  def test_indicator_and_empty_state
    assert_includes render(PhlexKit::ComboboxItemIndicator.new), "pk-combobox-item-indicator"
    html = render(PhlexKit::ComboboxEmptyState.new { "No results" })
    assert_includes html, "pk-combobox-empty pk-hidden"
    assert_includes html, %(data-phlex-kit--combobox-target="emptyState")
  end
end
