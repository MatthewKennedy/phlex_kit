# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 6, phase 2: transient open-state must not survive a Turbo cache
# restore. Turbo snapshots serialize reflected Stimulus values and stale aria
# attributes (aria-expanded / aria-activedescendant) even though :popover-open
# does not survive — so controllers must either close on turbo:before-cache or
# normalize the stale attributes when connect() re-runs on restored markup.
# Detaching and reattaching a root re-runs connect() on markup that still
# carries the stale attributes — the same shape a cache restore produces.
class Audit6TurboStateSystemTest < SystemTestCase
  include InteractionHelpers

  def dispatch_before_cache
    page.execute_script(%(document.dispatchEvent(new Event("turbo:before-cache"))))
  end

  # Re-run connect() on an element whose attributes are left as-is —
  # the DOM shape a Turbo cache restore hands Stimulus.
  RECONNECT = <<~JS
    const el = arguments[0];
    const parent = el.parentElement, next = el.nextSibling;
    el.remove();
    parent.insertBefore(el, next);
  JS

  def test_dropdown_menu_closes_on_turbo_before_cache
    visit "/docs/dropdown-menu"
    section = demo("Basic")
    section.find(".pk-dropdown-menu-trigger").click
    section.assert_selector ".pk-dropdown-menu-content:popover-open"

    dispatch_before_cache
    section.assert_no_selector ".pk-dropdown-menu-content:popover-open"
    root = section.find("[data-controller~='phlex-kit--dropdown-menu']", match: :first)
    refute_equal "true", root["data-phlex-kit--dropdown-menu-open-value"],
      "open flag still true in the would-be Turbo snapshot"
    assert_equal "false", root.find("[aria-haspopup='menu']")["aria-expanded"]
  end

  def test_alert_dialog_open_value_is_one_shot
    visit "/docs/alert-dialog"
    # Cuprite node refs go stale across remove/insert — drive the source
    # element entirely through JS on a stable selector.
    source_js = %(document.querySelector("[data-controller~='phlex-kit--alert-dialog']"))

    # Server-rendered open: true — connect() must open the dialog once...
    page.execute_script(<<~JS)
      const el = #{source_js};
      el.setAttribute("data-phlex-kit--alert-dialog-open-value", "true");
      const parent = el.parentElement, next = el.nextSibling;
      el.remove();
      parent.insertBefore(el, next);
    JS
    assert_selector "[role='alertdialog']"
    open_flag = page.evaluate_script(%(#{source_js}.getAttribute("data-phlex-kit--alert-dialog-open-value")))
    refute_equal "true", open_flag,
      "open: must be one-shot — a cache-restored reconnect would re-open a dismissed dialog"

    press(:escape)
    assert_no_selector "[role='alertdialog']"

    # ...and a reconnect of the (snapshot-shaped) source must NOT re-open it.
    page.execute_script(<<~JS)
      const el = #{source_js};
      const parent = el.parentElement, next = el.nextSibling;
      el.remove();
      parent.insertBefore(el, next);
    JS
    open_count = page.evaluate_script(%(document.querySelectorAll("[role='alertdialog']").length))
    assert_equal 0, open_count, "dismissed alert dialog resurrected on reconnect"
  end

  def test_select_connect_normalizes_stale_expanded_state
    visit "/docs/select"
    section = demo("Default")
    trigger = section.find("button[role='combobox']")
    trigger.click
    assert_selector ".pk-select-content:popover-open"
    assert_equal "true", trigger["aria-expanded"]

    root = section.find("[data-controller~='phlex-kit--select']", match: :first)
    page.execute_script(RECONNECT, root)

    assert_equal "false", trigger["aria-expanded"],
      "stale aria-expanded survived reconnect (Turbo cache restore)"
    assert_nil trigger["aria-activedescendant"]
  end

  def test_combobox_connect_normalizes_stale_expanded_state
    visit "/docs/combobox"
    section = demo("Multi-select with search")
    section.find("button.pk-combobox-trigger").click
    section.assert_selector ".pk-combobox-popover:popover-open"
    expanded = section.all("[aria-expanded='true']", minimum: 1)
    refute_empty expanded

    root = section.find("[data-controller~='phlex-kit--combobox']", match: :first)
    page.execute_script(RECONNECT, root)

    section.assert_no_selector "[aria-expanded='true']"
  end

  def test_menubar_connect_normalizes_stale_expanded_state
    visit "/docs/menubar"
    section = demo("Default")
    file_trigger = section.find(".pk-menubar-trigger", text: "File")
    file_trigger.click
    assert_equal "true", file_trigger["aria-expanded"]

    root = section.find("[data-controller~='phlex-kit--menubar']", match: :first)
    page.execute_script(RECONNECT, root)

    assert_equal "false", file_trigger["aria-expanded"],
      "stale aria-expanded survived reconnect (Turbo cache restore)"
  end
end
