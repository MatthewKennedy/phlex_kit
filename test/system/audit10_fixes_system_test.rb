# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 10 — browser gates for the round-10 fixes with a JS surface:
#   1. Select writes the chosen value as an ATTRIBUTE (survives a Turbo clone),
#      not just the .value property.
#   2. Select is a modal menu: the dismissing outside click is swallowed and
#      does NOT activate a focusable control under the pointer.
#   3. Popover's button trigger carries aria-haspopup="dialog".
#   4. A disabled ToggleGroup's rebuilt hidden input stays `disabled` after the
#      controller's connect()/reconcile(), so it still won't submit.
class Audit10FixesSystemTest < SystemTestCase
  include InteractionHelpers

  # Finding 1: selecting an item sets the hidden input's value ATTRIBUTE (the
  # thing a Turbo snapshot's cloneNode preserves), not only the dirty property.
  def test_select_writes_value_attribute
    visit "/docs/select"
    section = demo("Default")
    section.find(".pk-select-trigger").click
    assert_selector ".pk-select-content:popover-open"

    item = section.all(".pk-select-item").first
    value = item["data-value"]
    item.click
    assert_no_selector ".pk-select-content:popover-open"

    attr = page.evaluate_script(
      "arguments[0].querySelector('.pk-select-input').getAttribute('value')", section
    )
    assert_equal value, attr, "hidden input's value ATTRIBUTE must reflect the choice"
  end

  # Finding 4 (modal dismiss contract): an outside click on a focusable control
  # dismisses the open select WITHOUT also activating that control.
  def test_select_outside_click_is_swallowed
    visit "/docs/select"
    install_dismiss_probe
    section = demo("Default")
    section.find(".pk-select-trigger").click
    assert_selector ".pk-select-content:popover-open"

    find("#pk-dismiss-probe").click
    assert_no_selector ".pk-select-content:popover-open"
    refute page.evaluate_script("document.getElementById('pk-dismiss-probe').checked"),
           "the dismissing click must be swallowed, not toggle the outside checkbox"
  end

  # Finding 6: the button-triggered popover advertises aria-haspopup="dialog"
  # (shadcn/Radix parity), matching the button-less fallback path.
  def test_popover_button_trigger_has_haspopup
    visit "/gallery"
    wait_until("popover trigger should gain aria-haspopup on connect") do
      page.evaluate_script(
        "document.querySelector('.pk-popover-trigger button')?.getAttribute('aria-haspopup') === 'dialog'"
      )
    end
  end

  # Finding 3: after connect()/reconcile() rebuilds the hidden input, a disabled
  # group's input stays `disabled` — it must not start submitting post-JS.
  def test_disabled_toggle_group_input_stays_disabled_after_connect
    visit "/gallery"
    wait_until("disabled toggle group should keep a disabled hidden input") do
      page.evaluate_script(<<~JS)
        (() => {
          const input = document.querySelector("#pk-toggle-group-disabled input[type='hidden']");
          return !!input && input.disabled === true;
        })()
      JS
    end
  end

  private

  # A fixed, high-z-index checkbox in the top-left corner — an unambiguous
  # focusable outside-click target (mirrors audit8_seed_fixes_system_test).
  def install_dismiss_probe
    page.execute_script(<<~JS)
      const probe = document.createElement("input");
      probe.type = "checkbox";
      probe.id = "pk-dismiss-probe";
      probe.style.cssText = "position: fixed; top: 4px; left: 4px; z-index: 2147483647; width: 24px; height: 24px;";
      document.body.appendChild(probe);
    JS
  end
end
