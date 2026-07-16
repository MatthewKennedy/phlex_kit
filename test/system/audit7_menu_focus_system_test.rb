# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 7, task 8 — dropdown/context menu Tab-out close, page-wide key-hijack scoping,
# stale-aria normalization on connect, and navigation menu link click guard.
class Audit7MenuFocusSystemTest < SystemTestCase
  include InteractionHelpers

  RECONNECT = <<~JS
    const el = arguments[0];
    const parent = el.parentElement, next = el.nextSibling;
    el.remove();
    parent.insertBefore(el, next);
  JS

  # (a) Tab out of an open dropdown menu closes it — mirrors
  # audit5_menus_system_test.rb's menubar Tab-out test.
  def test_dropdown_menu_closes_on_tab_out
    visit "/docs/dropdown-menu"
    section = demo("Basic")
    section.click_button "Open"
    section.assert_selector ".pk-dropdown-menu-content:popover-open"
    root = section.find(".pk-dropdown-menu")

    10.times do
      break unless page.evaluate_script("arguments[0].contains(document.activeElement)", root)
      press(:tab)
    end
    refute page.evaluate_script("arguments[0].contains(document.activeElement)", root),
           "focus should have tabbed out of the dropdown menu"

    section.assert_no_selector ".pk-dropdown-menu-content:popover-open"
    assert_equal "false", section.find("button", text: "Open")["aria-expanded"]
  end

  # (a) Same for context menu, which has no natural Tab order but must still
  # close when focus is moved outside of it.
  def test_context_menu_closes_on_focus_leaving_the_menu
    visit "/docs/context-menu"
    section = demo("Basic")
    section.find(".pk-context-menu-trigger").right_click
    section.assert_selector ".pk-context-menu-content:popover-open"

    # Simulate focus tabbing away: move real focus to an unrelated element.
    page.execute_script(<<~JS)
      const outside = document.querySelector("h1");
      outside.setAttribute("tabindex", "-1");
      outside.focus();
    JS

    section.assert_no_selector ".pk-context-menu-content:popover-open"
  end

  # (b) With a context menu open, a keydown that lands on a real outside text
  # field must not be hijacked by the document-level menu key handler — the
  # focus move away from the menu already closes it (part of the same fix),
  # so the outside input's Home/End behavior is untouched.
  def test_context_menu_does_not_hijack_keys_typed_outside
    visit "/docs/context-menu"
    section = demo("Basic")
    section.find(".pk-context-menu-trigger").right_click
    section.assert_selector ".pk-context-menu-content:popover-open"

    page.execute_script(<<~JS)
      window.__pkOutsideInput = document.createElement("input");
      window.__pkOutsideInput.id = "pk-outside-input";
      window.__pkOutsideInput.value = "hello";
      document.body.appendChild(window.__pkOutsideInput);
      window.__pkOutsideInput.focus();
      window.__pkOutsideInput.setSelectionRange(2, 2);
    JS

    section.assert_no_selector ".pk-context-menu-content:popover-open"

    page.execute_script(<<~JS)
      const input = window.__pkOutsideInput;
      input.dispatchEvent(new KeyboardEvent("keydown", { key: "Home", bubbles: true, cancelable: true }));
    JS

    assert_equal "pk-outside-input", page.evaluate_script("document.activeElement.id"),
                 "focus must not have been stolen back into the (closed) menu"
    assert_equal "hello", page.evaluate_script("window.__pkOutsideInput.value"),
                 "outside input value must be untouched"
  end

  # (c) Reconnect (the Turbo-cache-restore shape) normalizes a stale
  # sub-trigger aria-expanded and a stale row aria-checked for both dropdown
  # and context menus.
  def test_dropdown_menu_reconnect_normalizes_stale_sub_trigger_and_checked_state
    visit "/docs/dropdown-menu"
    section = demo("Submenu")
    section.click_button "Open"
    sub_trigger = section.find(".pk-dropdown-menu-sub-trigger", text: "More Tools")
    # Stamp the stale attribute directly — the exact shape a Turbo snapshot
    # serializes (a real hover would leave the pointer parked on the row, and
    # the post-reconnect re-open would legitimately re-expand the submenu).
    # Tag the element with a stable probe attribute and re-locate it via
    # plain JS after reconnect: a detach/reattach force-closes the native
    # [popover] content and obsoletes held Cuprite node references
    # (CLAUDE.md's documented Cuprite gotcha).
    page.execute_script(<<~JS, sub_trigger)
      arguments[0].setAttribute("aria-expanded", "true");
      arguments[0].dataset.pkProbe = "sub-trigger";
    JS

    root = section.find("[data-controller~='phlex-kit--dropdown-menu']", match: :first)
    page.execute_script(RECONNECT, root)

    assert_equal "false", page.evaluate_script(%(document.querySelector('[data-pk-probe="sub-trigger"]').getAttribute("aria-expanded"))),
                 "stale sub-trigger aria-expanded survived reconnect"
  end

  def test_dropdown_menu_checkbox_reconnect_normalizes_stale_aria_checked
    visit "/docs/dropdown-menu"
    section = demo("Checkboxes")
    section.click_button "Open"
    row = section.find(".pk-dropdown-menu-checkbox-item", text: "Status Bar")
    input = row.find("input", visible: :all)
    # Flip the input's checked state directly (bypassing syncChecked) to
    # simulate the row's aria-checked drifting out of sync, the shape a
    # Turbo cache restore hands back to a reconnecting controller.
    page.execute_script("arguments[0].checked = false", input)
    assert_equal "true", row["aria-checked"], "precondition: aria-checked still stale"
    page.execute_script("arguments[0].dataset.pkProbe = 'checkbox-row'", row)

    root = section.find("[data-controller~='phlex-kit--dropdown-menu']", match: :first)
    page.execute_script(RECONNECT, root)

    assert_equal "false", page.evaluate_script(%(document.querySelector('[data-pk-probe="checkbox-row"]').getAttribute("aria-checked"))),
                 "stale aria-checked survived reconnect"
  end

  def test_context_menu_reconnect_normalizes_stale_sub_trigger_and_checked_state
    visit "/docs/context-menu"
    section = demo("Submenu")
    section.find(".pk-context-menu-trigger").right_click
    sub_trigger = section.find(".pk-context-menu-sub-trigger", text: "More Tools")
    # Stamp the stale attribute directly — the exact shape a Turbo snapshot
    # serializes (see the dropdown sibling above for why a real hover is
    # avoided).
    page.execute_script(<<~JS, sub_trigger)
      arguments[0].setAttribute("aria-expanded", "true");
      arguments[0].dataset.pkProbe = "sub-trigger";
    JS

    root = section.find("[data-controller~='phlex-kit--context-menu']", match: :first)
    page.execute_script(RECONNECT, root)

    assert_equal "false", page.evaluate_script(%(document.querySelector('[data-pk-probe="sub-trigger"]').getAttribute("aria-expanded"))),
                 "stale sub-trigger aria-expanded survived reconnect"
  end

  def test_context_menu_checkbox_reconnect_normalizes_stale_aria_checked
    visit "/docs/context-menu"
    section = demo("Checkboxes")
    section.find(".pk-context-menu-trigger").right_click
    row = section.find(".pk-context-menu-checkbox-item", text: "Show Bookmarks Bar")
    input = row.find("input", visible: :all)
    page.execute_script("arguments[0].checked = false", input)
    assert_equal "true", row["aria-checked"], "precondition: aria-checked still stale"
    page.execute_script("arguments[0].dataset.pkProbe = 'checkbox-row'", row)

    root = section.find("[data-controller~='phlex-kit--context-menu']", match: :first)
    page.execute_script(RECONNECT, root)

    assert_equal "false", page.evaluate_script(%(document.querySelector('[data-pk-probe="checkbox-row"]').getAttribute("aria-checked"))),
                 "stale aria-checked survived reconnect"
  end

  # (d) A nav-menu link with a real href navigates (here: to a same-page
  # fragment, so the test stays on the page) and closes the open panel,
  # rather than being swallowed like the default href="#" guard.
  def test_navigation_menu_link_with_real_href_closes_panel_on_click
    visit "/docs/navigation-menu"
    trigger = find(".pk-navigation-menu-trigger", text: "Getting started")
    page.execute_script("arguments[0].focus()", trigger)
    press(:down)
    assert_selector ".pk-navigation-menu-content:popover-open"

    link = find(".pk-navigation-menu-link", text: "Installation")
    page.execute_script(%(arguments[0].setAttribute("href", "#pk-real-target")), link)
    link.click

    assert_no_selector ".pk-navigation-menu-content:popover-open"
    assert_equal "#pk-real-target", page.evaluate_script("location.hash")
  end
end
