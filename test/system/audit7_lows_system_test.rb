# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Task 15 — audit round 7 clear-cut lows batch: the four items with real
# browser-observable behavior (2 command connect() aria normalization, 4
# input_otp rejected-keystroke restore, 11 combobox chip-removal focus,
# 15 select closed-trigger ArrowDown/ArrowUp).
class Audit7LowsSystemTest < SystemTestCase
  include InteractionHelpers

  # --- 2: a reconnect (the Turbo-cache-restore shape — see
  # audit6_turbo_state_system_test.rb) must not resurrect a stale
  # aria-selected row or aria-activedescendant on the input.
  def test_command_connect_clears_stale_aria_selected_and_activedescendant
    visit "/docs/command"
    section = demo("Basic")
    input = section.find(".pk-command-input")

    input.click
    press(:down) # highlight the first item — sets aria-selected + aria-activedescendant
    wait_until("first item never got aria-selected") do
      section.first(".pk-command-item")["aria-selected"] == "true"
    end
    assert input["aria-activedescendant"].present?

    root = section.find("[data-controller~='phlex-kit--command']")
    # Simulate a Turbo-cache-restore reconnect: detach/reattach re-runs
    # connect() on markup that still carries the stale attributes.
    page.execute_script(<<~JS, root.native)
      const el = arguments[0];
      const parent = el.parentElement, next = el.nextSibling;
      el.remove();
      parent.insertBefore(el, next);
    JS

    wait_until("aria-selected survived a reconnect") do
      section.all(".pk-command-item", visible: :all).none? { |item| item["aria-selected"] == "true" }
    end
    assert_nil section.find(".pk-command-input")["aria-activedescendant"]
  end

  # --- 4: typing a non-digit into a filled/selected OTP slot must restore
  # the prior digit (not blank it) and must not advance focus.
  def test_input_otp_rejects_non_digit_keystroke_without_erasing_or_advancing
    visit "/docs/input-otp"
    section = demo("Default")
    slots = section.all(".pk-input-otp-slot")

    slots.first.click
    press("5") # auto-advances to slot 2 on a valid digit
    assert_equal "5", slots.first.value

    # Click back into the now-filled slot 1 — onFocus selects its content —
    # then type a non-digit. Numeric filtering must reject it and restore
    # "5" rather than blanking the slot, and must not advance focus.
    slots.first.click
    press("a")
    assert_equal "5", slots.first.value
    assert_equal slots.first.native, active_element.native,
      "a rejected keystroke must not advance focus to the next slot"
  end

  # --- 11a: removing the currently-focused chip moves focus to the badge input.
  def test_combobox_badge_removal_refocuses_badge_input
    visit "/gallery"
    combobox = find(".pk-combobox:has(.pk-combobox-badge-trigger)")
    field = combobox.find(".pk-combobox-badge-input")

    field.click
    combobox.assert_selector ".pk-combobox-popover:popover-open"
    combobox.find(".pk-combobox-item", text: "ruby").click
    combobox.assert_selector ".pk-combobox-badge", count: 1

    combobox.first(".pk-combobox-badge-remove").click
    combobox.assert_no_selector ".pk-combobox-badge"
    wait_until("focus did not move to the badge input after chip removal") do
      active_element.matches_css?(".pk-combobox-badge-input")
    end
  end

  # --- 11b: the clear-all button hides itself once nothing is checked — if it
  # held focus, that focus must land on the badge input, not vanish.
  def test_combobox_clear_all_refocuses_badge_input_when_button_hides
    visit "/docs/combobox"
    section = demo("Clear Button")
    clear_button = section.find(".pk-combobox-clear-button", visible: :all)
    clear_button.click # pre-checked "Next.js" — clear button starts visible

    wait_until("focus did not move to the badge input after clear-all") do
      active_element.matches_css?(".pk-combobox-badge-input")
    end
    section.assert_no_selector ".pk-combobox-badge"
  end

  # --- 15: ArrowDown/ArrowUp on the CLOSED select trigger opens the listbox
  # and highlights the first/last option (APG select pattern).
  def test_select_closed_trigger_arrow_down_opens_and_highlights_first
    visit "/docs/select"
    section = demo("Default")
    trigger = section.find("button[role='combobox']")
    trigger.click
    press(:escape) # close it again — start from the CLOSED state
    section.assert_no_selector ".pk-select-content:popover-open"
    assert_equal "false", trigger["aria-expanded"]

    press(:down)
    section.assert_selector ".pk-select-content:popover-open"
    assert_equal "Apple", active_element.text
  end

  def test_select_closed_trigger_arrow_up_opens_and_highlights_last
    visit "/docs/select"
    section = demo("Default")
    trigger = section.find("button[role='combobox']")
    trigger.click
    press(:escape)
    section.assert_no_selector ".pk-select-content:popover-open"

    press(:up)
    section.assert_selector ".pk-select-content:popover-open"
    assert_equal "Grapes", active_element.text
  end
end
