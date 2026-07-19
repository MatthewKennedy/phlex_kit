# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 9, phase 2 — overlay Escape layering with popover=manual menus,
# plus AlertDialogContent's custom-role panel lookup.
#
# alert_dialog / sheet Escape handlers yielded only to a nested native
# dialog[open], not to an open [popover] menu (Select/DropdownMenu/Combobox)
# rendered inside the panel — so one Escape meant for the menu also dismissed
# the whole modal. The fix yields on two ordering-independent signals:
# event.defaultPrevented (an inner handler already consumed the key) and a live
# :popover-open descendant of the panel (a menu still open because the modal's
# handler ran first). Separately, alert_dialog #panel() now finds the panel by
# .pk-alert-dialog-panel instead of [role="alertdialog"], so a caller-supplied
# custom role no longer breaks the modal contract.
class Audit9Phase2OverlayEscapeSystemTest < SystemTestCase
  include InteractionHelpers

  def test_escape_closes_only_the_nested_menu_over_alert_dialog
    visit "/docs/alert-dialog"
    section = demo("With Nested Menu")
    within(section) { click_button "Show dialog" }
    assert_selector "[role='alertdialog']"

    # The cloned panel (with its menu) now lives at the end of <body>.
    click_button "Open menu"
    assert_selector ".pk-dropdown-menu-content:popover-open"

    press(:escape)
    wait_until("nested menu did not close on Escape") do
      page.evaluate_script("document.querySelectorAll('.pk-dropdown-menu-content:popover-open').length") == 0
    end
    # The Escape that closed the menu must not also dismiss the alert dialog.
    assert_selector "[role='alertdialog']"

    press(:escape)
    assert_no_selector "[role='alertdialog']"
  end

  def test_escape_closes_only_the_nested_menu_over_sheet
    visit "/docs/sheet"
    section = demo("With Nested Menu")
    within(section) { click_button "Open" }
    assert_selector ".pk-sheet-content"

    click_button "Open menu"
    assert_selector ".pk-dropdown-menu-content:popover-open"

    press(:escape)
    wait_until("nested menu did not close on Escape") do
      page.evaluate_script("document.querySelectorAll('.pk-dropdown-menu-content:popover-open').length") == 0
    end
    # The sheet must still be open after the menu-closing Escape.
    assert_selector ".pk-sheet-content"

    press(:escape)
    assert_no_selector ".pk-sheet-content"
  end

  # #panel() must locate the panel structurally so a custom role still dismisses
  # (a role-based lookup would return null and silently break the contract).
  def test_custom_role_alert_dialog_still_opens_and_dismisses
    visit "/docs/alert-dialog"
    section = demo("Custom Role")
    within(section) { click_button "Show dialog" }
    assert_selector ".pk-alert-dialog-panel[role='dialog']"

    press(:escape)
    assert_no_selector ".pk-alert-dialog-panel"
  end
end
