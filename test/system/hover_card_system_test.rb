# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# HoverCard's first system test file. Covers three bugs found in audit round
# 7: the Basic docs example's inline `display: flex` beat the UA
# `[popover]:not(:popover-open) { display: none }` rule (permanently visible
# closed card), the CSS had no `:popover-open` display gate for content to
# rely on, and the controller never normalized a stale `data-state="open"`
# left over from a Turbo cache restore (detach/reattach technique from
# audit6_turbo_state_system_test.rb simulates that restore).
class HoverCardSystemTest < SystemTestCase
  include InteractionHelpers

  def dispatch_before_cache
    page.execute_script(%(document.dispatchEvent(new Event("turbo:before-cache"))))
  end

  RECONNECT = <<~JS
    const el = arguments[0];
    const parent = el.parentElement, next = el.nextSibling;
    el.remove();
    parent.insertBefore(el, next);
  JS

  def test_closed_card_is_not_visible_on_docs_page
    visit "/docs/hover-card"
    section = demo("Basic")
    content = section.find(".pk-hover-card-content", visible: :all)

    refute content.visible?, "closed hover card content must not be visible"
    display = page.evaluate_script(
      "getComputedStyle(arguments[0]).display", content.native
    )
    assert_equal "none", display, "closed hover card content must compute display:none"
  end

  def test_closed_card_is_not_visible_in_gallery
    visit "/gallery"
    section = find("#hovercard")
    content = section.find(".pk-hover-card-content", visible: :all)

    refute content.visible?, "closed hover card content must not be visible"
    display = page.evaluate_script(
      "getComputedStyle(arguments[0]).display", content.native
    )
    assert_equal "none", display, "closed hover card content must compute display:none"
  end

  def test_hover_opens_the_card
    visit "/docs/hover-card"
    section = demo("Basic")
    section.find(".pk-hover-card-trigger").hover

    wait_until("hover card did not open") do
      section.has_selector?(".pk-hover-card-content:popover-open", visible: :all)
    end
    content = section.find(".pk-hover-card-content", visible: :all)
    assert content.visible?
    assert_equal "open", content["data-state"]
  end

  def test_closes_on_turbo_before_cache
    visit "/docs/hover-card"
    section = demo("Basic")
    section.find(".pk-hover-card-trigger").hover

    wait_until("hover card did not open") do
      section.has_selector?(".pk-hover-card-content:popover-open", visible: :all)
    end

    dispatch_before_cache

    section.assert_no_selector ".pk-hover-card-content:popover-open", visible: :all
    content = section.find(".pk-hover-card-content", visible: :all)
    assert_equal "closed", content["data-state"],
      "data-state must not survive a Turbo snapshot as stale \"open\""
  end

  def test_connect_normalizes_stale_data_state
    visit "/docs/hover-card"
    section = demo("Basic")
    content = section.find(".pk-hover-card-content", visible: :all)

    # Simulate a Turbo cache restore that serialized data-state="open" from a
    # previous (now-closed) popover — the popover itself cannot resurrect,
    # but the reflected data-state attribute would, unless connect() resyncs
    # it against the real :popover-open state.
    page.execute_script(%(arguments[0].dataset.state = "open"), content.native)

    root = section.find("[data-controller~='phlex-kit--hover-card']", match: :first)
    page.execute_script(RECONNECT, root.native)

    content = section.find(".pk-hover-card-content", visible: :all)
    assert_equal "closed", content["data-state"],
      "stale data-state=\"open\" survived reconnect (Turbo cache restore)"
  end
end
