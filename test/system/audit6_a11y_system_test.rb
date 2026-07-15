# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 6, phase 7: interaction/a11y fixes — tooltip SR wiring and
# hover-persistence (WCAG 1.4.13), dialog drag-select dismissal, navigation
# menu focusout, combobox Escape swallowing.
class Audit6A11ySystemTest < SystemTestCase
  include InteractionHelpers

  # The tooltip's aria-describedby must reach the element that actually takes
  # focus: when the trigger wraps a button/link, focus lands on the child and
  # a describedby left on the wrapper span is never announced.
  def test_tooltip_describedby_reaches_the_focusable_child
    visit "/docs/tooltip"
    section = demo("Default")
    content_id = section.find(".pk-tooltip-content", visible: :all)["id"]
    button = section.find(".pk-tooltip-trigger button")
    assert_equal content_id, button["aria-describedby"],
      "inner button (the real focus target) lacks aria-describedby"
  end

  # WCAG 1.4.13 Hoverable: the revealed bubble must be hoverable — with
  # pointer-events: none and a zero hide delay, crossing the trigger→bubble
  # gap dismissed it instantly.
  def test_tooltip_bubble_is_hoverable_when_revealed
    visit "/docs/tooltip"
    section = demo("Default")
    section.find(".pk-tooltip-trigger button").hover
    pointer_events = section.evaluate_script(
      %{getComputedStyle(this.querySelector(".pk-tooltip-content")).pointerEvents}
    )
    assert_equal "auto", pointer_events,
      "revealed tooltip bubble is pointer-events:none — it can never be hovered (WCAG 1.4.13)"
  end

  # Drag-selecting text that starts inside the dialog and releases over the
  # backdrop fires the click on <dialog> with outside coordinates — that must
  # NOT dismiss. Only a press that also STARTED outside the panel may.
  def test_dialog_survives_drag_select_ending_on_backdrop
    visit "/docs/dialog"
    within(demo("Default")) { click_button "Edit profile" }
    assert_selector "dialog.pk-dialog[open]"

    page.execute_script(<<~JS)
      const dialog = document.querySelector("dialog.pk-dialog[open]");
      const inner = dialog.querySelector("input, .pk-dialog-header, *");
      const r = inner.getBoundingClientRect();
      inner.dispatchEvent(new PointerEvent("pointerdown", { bubbles: true, detail: 1, clientX: r.x + 2, clientY: r.y + 2 }));
      dialog.dispatchEvent(new MouseEvent("click", { bubbles: true, detail: 1, clientX: 1, clientY: 1 }));
    JS
    assert_selector "dialog.pk-dialog[open]",
      wait: 0.5

    # A genuine backdrop press (down AND up outside) still dismisses.
    page.execute_script(<<~JS)
      const dialog = document.querySelector("dialog.pk-dialog[open]");
      dialog.dispatchEvent(new PointerEvent("pointerdown", { bubbles: true, detail: 1, clientX: 1, clientY: 1 }));
      dialog.dispatchEvent(new MouseEvent("click", { bubbles: true, detail: 1, clientX: 1, clientY: 1 }));
    JS
    assert_no_selector "dialog.pk-dialog[open]"
  end

  # Tabbing out of the navigation menu must close the open panel — menubar
  # wires focusout for this; navigation_menu forgot to.
  def test_navigation_menu_closes_when_focus_leaves
    visit "/docs/navigation-menu"
    section = demo("Default")
    trigger = section.find(".pk-menubar-trigger, .pk-navigation-menu-trigger", match: :first)
    page.execute_script("arguments[0].focus()", trigger)
    # Hover-open nav menus only toggle on keyboard activation (detail-0 click).
    press(:enter)
    assert_equal "true", trigger["aria-expanded"]

    page.execute_script(<<~JS)
      const outside = document.createElement("button");
      outside.id = "outside-focus-probe";
      document.body.appendChild(outside);
      outside.focus();
    JS
    wait_until("navigation menu panel stayed open after focus left the nav") do
      trigger["aria-expanded"] == "false"
    end
  ensure
    page.execute_script(%(document.getElementById("outside-focus-probe")?.remove()))
  end

  # Escape on a CLOSED combobox field must keep its default behavior (e.g.
  # cancelling an enclosing <dialog>) — the action's :prevent swallowed it
  # unconditionally.
  def test_combobox_escape_only_prevented_while_open
    visit "/docs/combobox"
    section = demo("Basic")
    field = section.find("[data-action*='closePopover']", match: :first, visible: :all)

    not_prevented = page.evaluate_script(<<~JS, field)
      (() => {
        const el = arguments[0];
        el.focus();
        return el.dispatchEvent(new KeyboardEvent("keydown", { key: "Escape", bubbles: true, cancelable: true }));
      })()
    JS
    assert not_prevented, "Escape was preventDefault-ed while the combobox popover was already closed"
  end

  # The dropdown submenu reveals with pure CSS; its trigger's aria-expanded
  # must mirror that state (menubar's syncSub pattern).
  def test_dropdown_sub_trigger_aria_expanded_follows_hover
    visit "/docs/dropdown-menu"
    section = demo("Submenu")
    section.find(".pk-dropdown-menu-trigger").click
    section.assert_selector ".pk-dropdown-menu-content:popover-open"

    sub_trigger = section.find(".pk-dropdown-menu-sub-trigger", visible: :all)
    assert_equal "false", sub_trigger["aria-expanded"]
    sub_trigger.hover
    wait_until("sub trigger aria-expanded never became true on hover") do
      sub_trigger["aria-expanded"] == "true"
    end
  end

  # Backspace-in-empty-field chip removal was wired as keydown.backspace —
  # not a Stimulus key filter, so Stimulus threw "unknown key filter" on
  # every keystroke and the feature never worked.
  def test_combobox_badge_backspace_removes_last_chip
    visit "/gallery"
    combobox = find(".pk-combobox:has(.pk-combobox-badge-trigger)")
    field = combobox.find(".pk-combobox-badge-input")

    field.click
    combobox.find(".pk-combobox-item", text: "ruby").click
    combobox.find(".pk-combobox-item", text: "rails").click
    combobox.assert_selector ".pk-combobox-badge", count: 2

    # Item clicks move focus — hand it back to the (empty) field first.
    page.execute_script("arguments[0].focus()", field)
    press(:backspace)
    combobox.assert_selector ".pk-combobox-badge", count: 1
  end

  # Enter after the highlighted item was removed (turbo stream re-render)
  # must not throw — the page's JS-error trap flunks the test if it does.
  def test_command_enter_survives_dynamic_item_removal
    visit "/docs/command"
    section = demo("Basic")
    input = section.find(".pk-command-input")
    input.click
    press(:down)
    page.execute_script(<<~JS)
      document.querySelectorAll("[data-phlex-kit--command-target='item']").forEach((el) => el.remove());
    JS
    press(:enter)
    # reaching here without the error trap firing is the assertion; make one
    # explicit check that the page is still alive.
    assert_selector ".pk-command-input"
  end
end
