# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Final whole-branch review of audit round 7: alert_dialog_controller.js's
# document-level keydown was missing the nested-`dialog[open]` Escape guard
# that Task 12 gave sheet_content_controller.js (see
# audit6_turbo_state_system_test.rb's
# test_escape_closes_only_the_topmost_overlay_dialog_over_sheet). A native
# Dialog opened from inside an AlertDialogContent panel closed BOTH on one
# Escape without it.
class Audit7FinalReviewSystemTest < SystemTestCase
  include InteractionHelpers

  def test_escape_closes_only_the_nested_dialog_over_alert_dialog
    visit "/docs/alert-dialog"
    section = demo("With Nested Dialog")
    within(section) { click_button "Show dialog" }
    assert_selector "[role='alertdialog']"

    # The alert dialog's content is now cloned into <body>, outside the
    # original demo section — its nested dialog trigger lives there too.
    click_button "Open nested dialog"
    assert_selector "dialog.pk-dialog[open]"

    press(:escape)
    wait_until("nested dialog did not close on Escape") do
      page.evaluate_script("document.querySelectorAll('dialog.pk-dialog[open]').length") == 0
    end
    # Escape that closed the nested dialog must not also dismiss the alert
    # dialog underneath.
    assert_selector "[role='alertdialog']"

    press(:escape)
    # second Escape must close the alert dialog underneath
    assert_no_selector "[role='alertdialog']"
  end
end
