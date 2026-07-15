# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5: the mobile overlay drawer must not strand the page inert
# when the viewport crosses to desktop while it is open — the scrim/drawer
# CSS stops applying at >=768px but the inert marks would stay.
class SidebarSystemTest < SystemTestCase
  include InteractionHelpers

  DESKTOP = [ 1400, 900 ].freeze
  MOBILE = [ 375, 800 ].freeze

  def teardown
    page.driver.resize(*DESKTOP)
    super
  end

  def test_mobile_drawer_closes_and_uninerts_when_resized_to_desktop
    visit "/docs/sidebar"
    page.driver.resize(*MOBILE)

    section = demo("Offcanvas (collapsible)")
    wrapper = section.find(".pk-sidebar-wrapper")
    section.find(".pk-sidebar-trigger").click
    wait_until("mobile drawer did not open") { wrapper["data-open"] }
    assert page.evaluate_script(
      %{document.querySelector("#{inset_selector}").inert}
    ), "SidebarInset should be inert behind the open mobile drawer"

    page.driver.resize(*DESKTOP)
    wait_until("drawer state was not cleared on breakpoint crossing") { wrapper["data-open"].nil? }
    refute page.evaluate_script(
      %{document.querySelector("#{inset_selector}").inert}
    ), "SidebarInset stayed inert after resizing to desktop"
  end

  private

  def inset_selector
    "section.docs-demo:has(h2#offcanvas-collapsible) .pk-sidebar-inset"
  end
end
