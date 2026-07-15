# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5: with no Tabs(default:), hydration must honor a server-marked
# TabsTrigger(active: true) instead of activating the first trigger.
class TabsServerActiveSystemTest < SystemTestCase
  include InteractionHelpers

  def test_hydration_keeps_server_marked_active_tab
    visit "/docs/tabs"
    section = demo("Server-marked active tab")

    billing = section.find(".pk-tabs-trigger", text: "Billing")
    assert_equal "active", billing["data-state"]
    assert_equal "true", billing["aria-selected"]
    assert_equal "inactive", section.find(".pk-tabs-trigger", text: "Overview")["data-state"]

    section.assert_selector ".pk-tabs-content", text: "Billing panel"
    section.assert_no_selector ".pk-tabs-content", text: "Overview panel"
  end
end
