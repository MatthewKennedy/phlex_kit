# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 9, phase 2 — combobox filter/highlight lifecycle and the command
# palette empty-state re-derivation.
class Audit9Phase2ComboboxCommandSystemTest < SystemTestCase
  include InteractionHelpers

  # Typing a printable char into a CLOSED input-trigger combobox opens the
  # popover — filtering was previously invisible while closed.
  def test_typing_opens_a_closed_input_trigger_combobox
    visit "/docs/combobox"
    section = demo("Basic")
    field = section.find(".pk-combobox-input-trigger-field")

    # Open (focusin), then Escape to close while keeping focus on the field.
    field.click
    press(:escape)
    section.assert_no_selector ".pk-combobox-popover:popover-open"

    press("s") # a printable keystroke changes the query while closed
    section.assert_selector ".pk-combobox-popover:popover-open"
  end

  # After filtering then closing without a pick, reopening shows the FULL list —
  # not the last query's leftover pk-hidden filtering.
  def test_reopened_combobox_shows_full_list_after_a_filtered_close
    visit "/docs/combobox"
    section = demo("Basic")
    field = section.find(".pk-combobox-input-trigger-field")

    field.click
    press("nuxt")
    wait_until("filter should hide the non-matching options") do
      section.all(".pk-combobox-item:not(.pk-hidden)", visible: :all).size == 1
    end

    press(:escape)
    section.assert_no_selector ".pk-combobox-popover:popover-open"

    field.click
    wait_until("reopened list should show all options") do
      section.all(".pk-combobox-item:not(.pk-hidden)", visible: :all).size ==
        section.all(".pk-combobox-item", visible: :all).size
    end
  end

  # A caret/modifier keyup (ArrowLeft) must NOT re-run the filter and wipe the
  # keyboard highlight.
  def test_caret_key_does_not_wipe_the_combobox_highlight
    visit "/docs/combobox"
    section = demo("Basic")
    field = section.find(".pk-combobox-input-trigger-field")

    field.click
    section.assert_selector ".pk-combobox-popover:popover-open"
    press(:down) # highlight the first option
    wait_until("first option should be highlighted") do
      section.all(".pk-combobox-item[aria-current='true']", visible: :all).size == 1
    end

    press(:left) # caret move — query unchanged
    assert_equal 1, section.all(".pk-combobox-item[aria-current='true']", visible: :all).size
  end

  # A command palette reconnecting (Turbo cache restore) with a no-match query
  # still in the input must re-derive the empty state, not blank-hide it.
  def test_command_reconnect_rederives_empty_state_from_live_query
    visit "/docs/command"
    section = demo("Basic")
    input = section.find(".pk-command-input")

    input.click
    press("zzzznotathing")
    wait_until("no-match query should reveal the empty state") do
      section.all(".pk-command-empty:not(.pk-hidden)", visible: :all).size == 1
    end

    # Simulate a Turbo cache restore: detach + reattach the controller root so
    # connect() re-runs on markup still carrying the query.
    root = section.find("[data-controller~='phlex-kit--command']", visible: :all)
    page.execute_script(<<~JS, root.native)
      const el = arguments[0];
      const parent = el.parentElement, next = el.nextSibling;
      el.remove();
      parent.insertBefore(el, next);
    JS

    wait_until("empty state should still be shown after reconnect") do
      section.all(".pk-command-empty:not(.pk-hidden)", visible: :all).size == 1
    end
  end
end
