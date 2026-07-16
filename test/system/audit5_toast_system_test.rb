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

  # Audit round 7: a single shared _paused boolean let any ONE pause source's
  # resume restart the timer while another source still held it paused.
  # Region-level pause (data-pk-toasts-paused on the <ol>) must survive the
  # individual toast's own pointerleave (pointer drifting from the toast into
  # the gap between toasts, still inside the hovered stack).
  def test_region_pause_survives_toast_pointerleave
    visit "/docs/toast"
    toast_id = "audit7-region-pause"
    page.execute_script(%(window.PhlexKit.toast("Region pause test", { duration: 5000, id: #{toast_id.to_json} })))
    assert_selector "#pk-toaster .pk-toast", text: "Region pause test"

    # Mirror the toaster's region-level pause (phlex-kit--toaster#_setPaused)
    # without depending on real mouse geometry over the stack.
    page.execute_script(<<~JS)
      document.getElementById("pk-toaster").dispatchEvent(new CustomEvent("phlex-kit:toast:pause"))
    JS

    # The toast's OWN pointerleave (e.g. pointer drifting into the inter-toast
    # gap) must not resume it while the region pause is still active.
    page.execute_script(<<~JS)
      document.getElementById(#{toast_id.to_json}).dispatchEvent(new PointerEvent("pointerleave", { bubbles: true }))
    JS

    # Assert synchronously — assert_no_selector's wait would mask a timer that
    # restarted and dismissed the toast out from under a real 5s duration, but
    # we want to catch a *restarted timer*, not just eventual removal.
    still_paused = page.evaluate_script(<<~JS)
      (() => {
        const el = document.getElementById(#{toast_id.to_json});
        const c = window.Stimulus.getControllerForElementAndIdentifier(el, "phlex-kit--toast");
        return c._timer === null;
      })()
    JS
    assert still_paused, "toast timer must stay paused while the region pause is still active"
    assert_selector "#pk-toaster .pk-toast", text: "Region pause test"

    # Resuming the region (the last active source) must restart the timer.
    page.execute_script(<<~JS)
      document.getElementById("pk-toaster").dispatchEvent(new CustomEvent("phlex-kit:toast:resume"))
    JS
    resumed = page.evaluate_script(<<~JS)
      (() => {
        const el = document.getElementById(#{toast_id.to_json});
        const c = window.Stimulus.getControllerForElementAndIdentifier(el, "phlex-kit--toast");
        return c._timer !== null;
      })()
    JS
    assert resumed, "toast timer must restart once every pause source clears"
  end

  # Audit round 7: _restart() (fired by the toaster's _mutate, e.g.
  # PhlexKit.toast.promise resolving) used to ignore _paused entirely — it
  # armed a fresh live timer even while the toast was hovered, and _pause()'s
  # early return meant that timer could never be paused afterwards.
  def test_restart_while_hovered_arms_paused_until_unhover
    visit "/docs/toast"
    toast_id = "audit7-restart-hover"
    page.execute_script(%(window.PhlexKit.toast("Restart test", { duration: 4000, id: #{toast_id.to_json} })))
    assert_selector "#pk-toaster .pk-toast", text: "Restart test"

    page.execute_script(<<~JS)
      document.getElementById(#{toast_id.to_json}).dispatchEvent(new PointerEvent("pointerenter", { bubbles: true }))
    JS

    # A short duration so an (incorrect) live timer would fire almost
    # immediately, making the bug easy to observe if it regresses.
    page.execute_script(<<~JS)
      const el = document.getElementById(#{toast_id.to_json});
      el.setAttribute("data-phlex-kit--toast-duration-value", "80");
      el.dispatchEvent(new CustomEvent("phlex-kit:toast:restart", { bubbles: true }));
    JS

    armed_paused = page.evaluate_script(<<~JS)
      (() => {
        const el = document.getElementById(#{toast_id.to_json});
        const c = window.Stimulus.getControllerForElementAndIdentifier(el, "phlex-kit--toast");
        return c._timer === null && c._pauseSources.has("hover");
      })()
    JS
    assert armed_paused, "restart while hovered must arm paused, not a live timer"

    # Unhovering is the only thing that should let it dismiss.
    page.execute_script(<<~JS)
      document.getElementById(#{toast_id.to_json}).dispatchEvent(new PointerEvent("pointerleave", { bubbles: true }))
    JS
    wait_until("toast should auto-dismiss once unhovered") do
      page.evaluate_script(%(document.getElementById(#{toast_id.to_json}))).nil?
    end
  end

  # Audit round 7: ToastAction's dismiss binding used to be gated `if @on`, so
  # a server-rendered ToastAction.new(label: "OK") with no on: of its own was
  # inert — contradicting the comment above the binding and the clone path
  # (the toaster always force-dismisses after onClick).
  def test_toast_action_without_on_dismisses_its_toast
    visit "/docs/toast"

    fixture = Class.new(Phlex::HTML) do
      def view_template
        render PhlexKit::ToastItem.new(variant: :default, id: "audit7-action-dismiss", duration: 0) do
          render PhlexKit::ToastTitle.new { "Plain action" }
          render PhlexKit::ToastAction.new(label: "OK")
        end
      end
    end.new.call

    page.execute_script(<<~JS)
      document.getElementById("pk-toaster").insertAdjacentHTML("beforeend", #{fixture.to_json})
    JS
    assert_selector "#audit7-action-dismiss", text: "OK"

    click_button "OK"

    closing = page.evaluate_script(%(document.getElementById("audit7-action-dismiss")?.dataset.state === "closing"))
    assert closing, "clicking a ToastAction without on: must dismiss its own toast"
    wait_until("toast should be removed after dismiss") do
      page.evaluate_script(%(document.getElementById("audit7-action-dismiss"))).nil?
    end
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
