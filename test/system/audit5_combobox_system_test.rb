# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5 — Combobox: filtering must fire on a bare `input` event
# (context-menu paste / IME composition send no keyup/search), and the
# toggle-all row must be a real option inside the listbox that arrow keys
# can reach and Enter can activate.
class Audit5ComboboxSystemTest < SystemTestCase
  include InteractionHelpers

  def test_search_filters_on_bare_input_event
    visit "/docs/combobox"
    section = demo("Multi-select with search")
    section.find("button.pk-combobox-trigger").click
    section.assert_selector ".pk-combobox-popover:popover-open"

    # Simulate a context-menu paste: value set + `input` only — no keyup.
    search = section.find(".pk-combobox-search-input")
    page.execute_script(<<~JS, search)
      arguments[0].value = "ban";
      arguments[0].dispatchEvent(new Event("input", { bubbles: true }));
    JS

    section.assert_selector ".pk-combobox-item:not(.pk-hidden)", text: "Banana", count: 1
    section.assert_no_selector ".pk-combobox-item:not(.pk-hidden)", text: "Apple"
    section.assert_no_selector ".pk-combobox-item:not(.pk-hidden)", text: "Select all"
  end

  def test_toggle_all_sits_inside_listbox_and_is_arrow_reachable
    visit "/docs/combobox"
    section = demo("Multi-select with search")

    # (a) No role=option may sit outside a role=listbox — page-wide sweep.
    orphans = page.evaluate_script(
      %{[...document.querySelectorAll("[role='option']")].filter((el) => !el.closest("[role='listbox']")).length}
    )
    assert_equal 0, orphans, "found role=option element(s) outside a role=listbox"

    section.find("button.pk-combobox-trigger").click
    section.assert_selector ".pk-combobox-popover:popover-open"

    # (b) The first ArrowDown lands on the Select all row and the combobox
    # field exposes it via aria-activedescendant…
    press(:down)
    current = section.find(".pk-combobox-item[aria-current='true']")
    assert_includes current.text, "Select all"
    search = section.find(".pk-combobox-search-input")
    assert_equal current[:id], search["aria-activedescendant"]

    # …and Enter activates it: every option becomes checked + selected.
    press(:enter)
    wait_until("toggle-all did not check all the options") do
      section.all(".pk-combobox-checkbox", visible: :all).all?(&:checked?)
    end
    assert_equal "true", current["aria-selected"]
  end
end
