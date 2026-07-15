# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5 — command palette: host-rendered (dynamic) items join the
# search index and get ids, and the command dialog inerts the page behind it
# like the other clone-based modals.
class Audit5CommandSystemTest < SystemTestCase
  include InteractionHelpers

  # Items appended after connect() must be id'd (itemTargetConnected) and
  # findable by the filter — the index is live, not a connect()-time snapshot.
  def test_host_appended_item_is_indexed_and_filterable
    visit "/docs/command"
    section = demo("Basic")
    input = section.find(".pk-command-input")

    page.execute_script(<<~JS, section.find("[group-items]"))
      const group = arguments[0];
      const item = document.createElement("a");
      item.className = "pk-command-item";
      item.href = "#";
      item.setAttribute("role", "option");
      item.setAttribute("data-phlex-kit--command-target", "item");
      item.dataset.value = "zebra crossing";
      item.textContent = "Zebra Crossing";
      group.appendChild(item);
    JS

    # itemTargetConnected assigns a listbox-derived id to the late arrival.
    late_item = section.find(".pk-command-item", text: "Zebra Crossing")
    wait_until("appended item never received a listbox-derived id") do
      late_item["id"].to_s.start_with?("pk-command-list-")
    end

    input.send_keys "zebra"
    section.assert_selector ".pk-command-item.pk-hidden", count: 3, visible: :all
    visible = section.all(".pk-command-item:not(.pk-hidden)")
    assert_equal 1, visible.size
    assert_equal "Zebra Crossing", visible.first.text
    section.assert_no_selector ".pk-command-empty"

    # And it disappears from results once removed (itemTargetDisconnected).
    page.execute_script("arguments[0].remove()", late_item)
    input.send_keys "z" # re-run the filter ("zebraz" matches nothing)
    input.send_keys [ :backspace ] # back to "zebra"
    section.assert_selector ".pk-command-item.pk-hidden", count: 3, visible: :all
    section.assert_selector ".pk-command-empty", text: "No results found."
  end

  # The dialog overlay must inert everything behind it (same modal contract as
  # alert_dialog/sheet) and restore per-element state on every close path.
  def test_command_dialog_inerts_background_and_restores_on_escape
    visit "/docs/command"
    trigger = find("button", text: "Open command palette")
    trigger.click

    assert_selector "body > div[data-phlex-kit--command-dialog-instance]"
    assert background_inert?(".pk-command-dialog"), "expected background body children to be inert"

    press(:escape)
    assert_no_selector "body > div[data-phlex-kit--command-dialog-instance]"
    assert background_inert_cleared?, "inert was not cleared after palette dismiss"
    # Focus restore only works if the opener was un-inerted first.
    assert_includes active_element.text, "Open command palette"

    # Reopening re-inerts (the saved-state list is rebuilt per open).
    trigger.click
    assert_selector "body > div[data-phlex-kit--command-dialog-instance]"
    assert background_inert?(".pk-command-dialog"), "expected background inert again on reopen"
    press(:escape)
    assert background_inert_cleared?, "inert was not cleared after second dismiss"
  end

  # Backdrop click is the other dismiss path — it must also un-inert.
  def test_command_dialog_backdrop_click_clears_inert
    visit "/docs/command"
    find("button", text: "Open command palette").click
    assert_selector "body > div[data-phlex-kit--command-dialog-instance]"
    assert background_inert?(".pk-command-dialog"), "expected background body children to be inert"

    panel = rect_of(find(".pk-command-dialog"))
    click_at(panel["left"] - 40, panel["top"] - 40)
    assert_no_selector "body > div[data-phlex-kit--command-dialog-instance]"
    assert background_inert_cleared?, "inert was not cleared after backdrop dismiss"
  end
end
