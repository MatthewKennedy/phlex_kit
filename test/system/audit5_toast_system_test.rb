# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5 browser coverage: hover-pause in an expand:true toast region
# (pause used to piggyback on the expand-state transition), global toast API
# teardown, and the toggle-group change event.
class Audit5ToastSystemTest < SystemTestCase
  include InteractionHelpers

  # The docs layout renders the shared region collapsed, so re-connect it with
  # expand: true (Stimulus reuses the controller for the same element; connect
  # re-runs and reads the new value). The detach/re-attach round-trip also
  # exercises the global API teardown: window.PhlexKit.toast must be cleared
  # while the region is gone and re-registered when it comes back.
  def test_expanded_region_still_pauses_auto_dismiss_on_hover
    visit "/docs/toast"

    page.execute_script(<<~JS)
      window.__pkRegion = document.getElementById("pk-toaster-region");
      window.__pkRegion.setAttribute("data-phlex-kit--toaster-expand-value", "true");
      window.__pkRegion.remove();
    JS
    wait_until("window.PhlexKit.toast should be cleared after region teardown") do
      page.evaluate_script("window.PhlexKit.toast === undefined")
    end

    page.execute_script("document.body.appendChild(window.__pkRegion)")
    wait_until("window.PhlexKit.toast should re-register on reconnect") do
      page.evaluate_script("typeof window.PhlexKit.toast === 'function'")
    end

    page.execute_script("window.PhlexKit.toast('Expanded hover test')")
    assert_selector "#pk-toaster .pk-toast", text: "Expanded hover test"

    # Hovering the (already expanded) stack must still dispatch the pause —
    # the toaster mirrors it as data-pk-toasts-paused on the <ol>.
    find("#pk-toaster").hover
    assert_selector "#pk-toaster[data-pk-toasts-paused]"

    # Leaving releases the pause; the stack itself stays expanded.
    find("h1").hover
    assert_no_selector "#pk-toaster[data-pk-toasts-paused]"
    assert_selector "#pk-toaster .pk-toast", text: "Expanded hover test"
  end

  def test_toggle_group_dispatches_change_event_with_selected_values
    visit "/docs/toggle-group"
    page.execute_script(<<~JS)
      window.__pkChanges = [];
      document.addEventListener("phlex-kit--toggle-group:change", (e) => window.__pkChanges.push(e.detail));
    JS

    # Single-select (role=radiogroup): detail carries the one selected value.
    within(demo("Default")) { click_button "Right" }
    wait_until("single-select change event not dispatched") do
      page.evaluate_script("window.__pkChanges.length") == 1
    end
    assert_equal({ "value" => "right" }, page.evaluate_script("window.__pkChanges[0]"))

    # Multi-select: detail carries the array of pressed values.
    within(demo("Spacing")) { first(".pk-toggle-group").click_button "Bold" }
    wait_until("multi-select change event not dispatched") do
      page.evaluate_script("window.__pkChanges.length") == 2
    end
    assert_equal({ "value" => [ "bold" ] }, page.evaluate_script("window.__pkChanges[1]"))
  end
end
