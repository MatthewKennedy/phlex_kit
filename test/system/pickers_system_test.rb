# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Select keyboard navigation, the Command palette (dialog + inline flavours),
# and the Combobox badge-trigger layout's chip removal.
class PickersSystemTest < SystemTestCase
  include InteractionHelpers

  def test_select_keyboard_navigation_and_escape
    visit "/docs/select"
    section = demo("Default")
    trigger = section.find("button[role='combobox']")
    trigger.click
    assert_selector ".pk-select-content:popover-open"

    # Click-open focuses the first option; every item is tabindex=-1 so Tab
    # exits the widget instead of walking the options.
    assert_equal "Apple", active_element.text
    section.all(".pk-select-item", visible: :all).each do |item|
      assert_equal "-1", item["tabindex"]
    end

    panel = section.find(".pk-select-content", visible: :all)
    %w[Banana Blueberry Grapes].each do |fruit|
      press(:down)
      focused = active_element
      assert focused.matches_css?(".pk-select-item"), "focused element should be a .pk-select-item"
      assert_equal fruit, focused.text
      assert option_fully_visible?(focused, panel), "#{fruit} scrolled out of the panel viewport"
    end

    press(:home)
    assert_equal "Apple", active_element.text

    press(:escape)
    assert_no_selector ".pk-select-content:popover-open"
    assert_equal "false", trigger["aria-expanded"]
    assert active_element.matches_css?("button[role='combobox']"), "Escape should refocus the trigger"
  end

  def test_command_dialog_filters_unlocks_scroll_and_restores_focus_on_escape
    visit "/docs/command"
    trigger = find("button", text: "Open command palette")
    trigger.click

    overlay = find("body > div[data-phlex-kit--command-dialog-instance]")
    input = overlay.find(".pk-command-input")
    assert active_element.matches_css?(".pk-command-input"), "opening should focus the palette input"

    input.send_keys "zzzz"
    overlay.assert_selector ".pk-command-item.pk-hidden", count: 5, visible: :all
    overlay.assert_selector ".pk-command-empty", text: "No results found."

    press(:escape)
    assert_no_selector "body > div[data-phlex-kit--command-dialog-instance]"
    wait_until("body scroll was not unlocked after palette dismiss") do
      page.evaluate_script("document.body.style.overflow") == ""
    end
    assert_includes active_element.text, "Open command palette"
  end

  def test_inline_command_palette_survives_escape_with_query_cleared
    visit "/docs/command"
    section = demo("Basic")
    input = section.find(".pk-command-input")

    input.send_keys "zzzz"
    section.assert_selector ".pk-command-item.pk-hidden", count: 3, visible: :all
    section.assert_selector ".pk-command-empty", text: "No results found."

    press(:escape)
    # Inline palettes survive Escape — only the query resets.
    section.assert_selector ".pk-command"
    assert_equal "", input.value
    section.assert_selector ".pk-command-item", count: 3
    section.assert_no_selector ".pk-command-item.pk-hidden", visible: :all
    section.assert_no_selector ".pk-command-empty"
  end

  def test_combobox_badge_chip_removal_keeps_panel_closed
    visit "/gallery"
    combobox = find(".pk-combobox:has(.pk-combobox-badge-trigger)")
    field = combobox.find(".pk-combobox-badge-input")

    field.click
    combobox.assert_selector ".pk-combobox-popover:popover-open"
    combobox.find(".pk-combobox-item", text: "ruby").click
    combobox.find(".pk-combobox-item", text: "rails").click
    combobox.assert_selector ".pk-combobox-badge", count: 2

    field.send_keys(:escape)
    combobox.assert_no_selector ".pk-combobox-popover:popover-open"
    assert_equal "false", field["aria-expanded"]

    # Removing a chip must not bounce the popover back open (the remove
    # button's focusin lands inside the click-to-open trigger).
    combobox.first(".pk-combobox-badge-remove").click
    combobox.assert_selector ".pk-combobox-badge", count: 1
    combobox.assert_no_selector ".pk-combobox-popover:popover-open"
    assert_equal "false", field["aria-expanded"]
  end

  private

  # The focused option must sit fully inside the panel's scroll viewport.
  def option_fully_visible?(option, panel)
    o = rect_of(option)
    p = rect_of(panel)
    o["top"] >= p["top"] && o["bottom"] <= p["bottom"]
  end
end
