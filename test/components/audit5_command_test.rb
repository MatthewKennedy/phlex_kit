# frozen_string_literal: true

require "test_helper"

# Audit round 5 — command palette: CommandGroup names its role="group" items
# wrapper via aria-labelledby → the [group-heading] div's generated id
# (matching cmdk/shadcn).
class Audit5CommandTest < Minitest::Test
  include RenderHelper

  def test_titled_group_wires_aria_labelledby_to_heading_id
    html = render(PhlexKit::CommandGroup.new(title: "Pages") { "x" })
    heading_id = html[/id="(pk-command-group-heading-\h{8})"[^>]*group-heading="Pages"/, 1]
    refute_nil heading_id, "heading should carry a generated pk-command-group-heading id: #{html}"
    assert_includes html, %(role="group" aria-labelledby="#{heading_id}")
  end

  def test_untitled_group_renders_no_heading_and_no_labelledby
    html = render(PhlexKit::CommandGroup.new { "x" })
    refute_includes html, "group-heading"
    refute_includes html, "aria-labelledby"
    assert_includes html, %(role="group")
  end

  def test_heading_ids_are_unique_per_render
    first = render(PhlexKit::CommandGroup.new(title: "Pages") { "x" })[/id="(pk-command-group-heading-\h{8})"/, 1]
    second = render(PhlexKit::CommandGroup.new(title: "Pages") { "x" })[/id="(pk-command-group-heading-\h{8})"/, 1]
    refute_nil first
    refute_equal first, second
  end
end
