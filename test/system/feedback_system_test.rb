# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Feedback surfaces: toast spawn/order/dismiss + stacking, hover card
# open/Escape, tooltip focus-visible reveal, calendar rendering contracts.
class FeedbackSystemTest < SystemTestCase
  include InteractionHelpers

  def test_toast_spawns_with_status_role_newest_last_and_close_button_dismisses
    visit "/docs/toast"
    section = demo("Default")

    section.click_button "Default"
    assert_selector ".pk-toast[role='status']", text: "Event has been created"

    section.click_button "Success"
    assert_selector "#pk-toaster .pk-toast", count: 2
    assert_includes page.evaluate_script("document.querySelector('#pk-toaster').lastElementChild.textContent"),
      "Saved", "the newest toast should be the list's last child"

    # The docs region renders close_button: true — dismiss the front toast.
    find("#pk-toaster .pk-toast:last-child .pk-toast-close").click
    assert_no_selector "#pk-toaster .pk-toast", text: "Saved"
    assert_selector "#pk-toaster .pk-toast", count: 1
  end

  def test_toast_stacking_applies_translate3d_to_non_front_toasts
    visit "/docs/toast"
    section = demo("Default")
    3.times { section.click_button "Default" }
    assert_selector "#pk-toaster .pk-toast", count: 3

    non_front_transforms = page.evaluate_script(<<~JS)
      [...document.querySelectorAll("#pk-toaster .pk-toast")].slice(0, -1)
        .map((el) => el.style.transform)
    JS
    assert_equal 2, non_front_transforms.size
    non_front_transforms.each do |transform|
      assert_includes transform, "translate3d", "stacked toast should carry the inline stacking transform"
    end
  end

  def test_hover_card_opens_on_hover_and_closes_on_escape
    visit "/docs/hover-card"
    section = demo("Basic")

    section.find(".pk-hover-card-trigger").hover
    # The controller opens after its 200ms delay — Capybara waits it out.
    section.assert_selector ".pk-hover-card-content:popover-open", text: "@nextjs"

    press(:escape)
    section.assert_no_selector ".pk-hover-card-content:popover-open"
  end

  def test_tooltip_shows_on_keyboard_focus_and_escape_dismisses
    visit "/docs/tooltip"
    section = demo("Default")

    # Real Tab presses so :focus-visible matches: from the demo's Preview tab
    # (focused via script), Tab lands on the tabpanel (tabindex=0), a second
    # Tab lands keyboard focus on the tooltip trigger.
    page.execute_script("arguments[0].focus()", section.find(".pk-tabs-trigger", text: "Preview"))
    press(:tab)
    press(:tab)
    trigger = active_element
    assert trigger.matches_css?(".pk-tooltip-trigger"), "expected Tab to land on the tooltip trigger"
    section.assert_selector ".pk-tooltip-content", text: "Add to library"

    # WCAG 1.4.13: Escape hides the bubble while focus stays on the trigger.
    press(:escape)
    section.assert_no_selector ".pk-tooltip-content"
    assert active_element.matches_css?(".pk-tooltip-trigger")
  end

  def test_calendar_dropdown_caption_bounds_and_day_labels
    visit "/docs/calendar"

    within(demo("Month and Year Selector")) do
      # selected_date 2026-06-12 → June (index 5) / 2026 preselected.
      assert_equal "5", find("select[aria-label='Month']").value
      assert_equal "2026", find("select[aria-label='Year']").value
    end

    within(demo("Disabled past dates")) do
      # min_date: Date.today — the view already sits on the earliest month.
      assert_selector ".pk-calendar-prev:disabled"
    end

    within(demo("Basic")) do
      # Day buttons carry full-date accessible names once connected.
      expected = Date.new(2026, 6, 12).strftime("%A, %B %-d, %Y")
      selected = find("td[aria-selected='true'] button[name='day']")
      assert_equal expected, selected["aria-label"]
    end
  end
end
