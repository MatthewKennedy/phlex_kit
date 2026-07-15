# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# The modal contract: Dialog's backdrop-vs-padding dismissal + scroll lock,
# AlertDialog's inert background + focus trap, Sheet's inert background +
# description wiring — and focus restore to the opener on every close path.
class ModalsSystemTest < SystemTestCase
  include InteractionHelpers

  def test_dialog_padding_click_stays_open_backdrop_click_closes_and_restores_scroll
    visit "/docs/dialog"
    within(demo("Default")) { click_button "Edit profile" }
    assert_selector "dialog.pk-dialog[open]"
    assert_equal "hidden", page.evaluate_script("document.body.style.overflow")

    rect = rect_of(find("dialog.pk-dialog[open]"))

    # Just inside the dialog's own box — e.target is the <dialog> exactly as
    # for a backdrop click, so only the coordinate check keeps this open.
    click_at(rect["left"] + 3, rect["top"] + 3)
    assert_selector "dialog.pk-dialog[open]"

    # Outside the box → real ::backdrop click → dismiss.
    click_at(rect["left"] - 40, rect["top"] - 40)
    assert_no_selector "dialog.pk-dialog[open]"

    # The <dialog> close event is queued — wait for the overflow restore.
    wait_until("body overflow was not restored after dialog close") do
      page.evaluate_script("document.body.style.overflow") == ""
    end
  end

  def test_alert_dialog_inerts_background_traps_tab_and_escape_restores_focus
    visit "/docs/alert-dialog"
    within(demo("Basic")) { click_button "Show dialog" }
    assert_selector "[role='alertdialog']"
    assert background_inert?("[role='alertdialog']"), "expected background body children to be inert"

    # The overlay is deliberately NOT a dismiss surface on an alert dialog.
    click_at(15, 15)
    assert_selector "[role='alertdialog']"

    # Tab cycles inside the panel (Cancel → Continue → wrap) — never escapes.
    3.times do
      press(:tab)
      assert page.evaluate_script("document.querySelector(\"[role='alertdialog']\").contains(document.activeElement)"),
        "focus escaped the alert dialog panel"
    end

    press(:escape)
    assert_no_selector "[role='alertdialog']"
    assert background_inert_cleared?, "inert was not cleared after close"
    assert_equal "Show dialog", active_element.text
  end

  def test_sheet_inerts_background_wires_describedby_and_escape_restores_focus
    visit "/docs/sheet"
    within(demo("Default")) { click_button "Open" }
    panel = find(".pk-sheet-content[role='dialog']")

    describedby = panel["aria-describedby"]
    refute_nil describedby, "panel should point aria-describedby at the description"
    assert_equal "Make changes to your profile here. Click save when you're done.",
      find("##{describedby}").text
    assert background_inert?(".pk-sheet-content"), "expected background body children to be inert"

    press(:escape)
    assert_no_selector ".pk-sheet-content[role='dialog']"
    assert background_inert_cleared?, "inert was not cleared after close"
    assert_equal "Open", active_element.text
  end
end
