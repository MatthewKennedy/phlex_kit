# frozen_string_literal: true

require "test_helper"

class A11yTabsAccordionTest < Minitest::Test
  include RenderHelper

  def test_tabs_trigger_renders_aria_selected_tabindex_and_ids
    html = render(PhlexKit::TabsTrigger.new(value: "account") { "Account" })
    assert_includes html, %(aria-selected="false")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(id="pk-tabs-trigger-account")
    assert_includes html, %(aria-controls="pk-tabs-panel-account")

    active = render(PhlexKit::TabsTrigger.new(value: "account", active: true) { "Account" })
    assert_includes active, %(aria-selected="true")
    assert_includes active, %(tabindex="0")
  end

  def test_tabs_content_renders_tabpanel_role_tabindex_and_labelledby
    html = render(PhlexKit::TabsContent.new(value: "account") { "panel" })
    assert_includes html, %(role="tabpanel")
    assert_includes html, %(tabindex="0")
    assert_includes html, %(id="pk-tabs-panel-account")
    assert_includes html, %(aria-labelledby="pk-tabs-trigger-account")
  end

  def test_accordion_trigger_renders_aria_expanded_inside_a_heading
    html = render(PhlexKit::AccordionTrigger.new { "Question" })
    assert_includes html, %(aria-expanded="false")
    assert_includes html, %(<h3 class="pk-accordion-heading">)

    open = render(PhlexKit::AccordionDefaultTrigger.new(open: true, heading_level: 2) { "Question" })
    assert_includes open, %(aria-expanded="true")
    assert_includes open, %(<h2 class="pk-accordion-heading">)

    assert_raises(ArgumentError) { PhlexKit::AccordionTrigger.new(heading_level: 7) }
  end

  def test_disabled_accordion_trigger_button_is_disabled
    html = render(PhlexKit::AccordionDefaultTrigger.new(disabled: true) { "Question" })
    assert_includes html, %(disabled)

    enabled = render(PhlexKit::AccordionDefaultTrigger.new { "Question" })
    refute_includes enabled, %(disabled)
  end

  def test_accordion_content_is_a_region
    assert_includes render(PhlexKit::AccordionContent.new { "body" }), %(role="region")
  end
end
