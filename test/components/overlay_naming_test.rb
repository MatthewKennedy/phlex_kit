# frozen_string_literal: true

require "test_helper"

# Every overlay content names itself the same way: labelledby:/describedby:
# (0.16.0 — only DialogContent had them, CommandDialogContent had a one-off
# aria_label:, and sheet/drawer/alert_dialog had nothing).
class OverlayNamingTest < Minitest::Test
  include RenderHelper

  OVERLAY_CONTENTS = [
    PhlexKit::DialogContent, PhlexKit::SheetContent, PhlexKit::DrawerContent,
    PhlexKit::AlertDialogContent, PhlexKit::CommandDialogContent
  ].freeze

  def test_every_overlay_content_takes_labelledby_and_describedby
    OVERLAY_CONTENTS.each do |klass|
      params = klass.instance_method(:initialize).parameters
      assert_includes params, [ :key, :labelledby ], "#{klass} lacks labelledby:"
      assert_includes params, [ :key, :describedby ], "#{klass} lacks describedby:"
    end
  end

  def test_sheet_content_renders_the_aria_relationships
    html = render(PhlexKit::SheetContent.new(labelledby: "t", describedby: "d")) { "x" }
    assert_includes html, %(aria-labelledby="t")
    assert_includes html, %(aria-describedby="d")
  end

  def test_drawer_content_renders_the_aria_relationships
    html = render(PhlexKit::DrawerContent.new(labelledby: "t", describedby: "d")) { "x" }
    assert_includes html, %(aria-labelledby="t")
    assert_includes html, %(aria-describedby="d")
  end

  def test_alert_dialog_content_renders_the_aria_relationships
    html = render(PhlexKit::AlertDialogContent.new(labelledby: "t", describedby: "d")) { "x" }
    assert_includes html, %(aria-labelledby="t")
    assert_includes html, %(aria-describedby="d")
  end

  # The palette keeps its default accessible name, but labelledby: now wins
  # over it the same way it does everywhere else.
  def test_command_dialog_keeps_a_default_name_and_honours_labelledby
    assert_includes render(PhlexKit::CommandDialogContent.new { "x" }), %(aria-label="Command palette")
    labelled = render(PhlexKit::CommandDialogContent.new(labelledby: "t") { "x" })
    assert_includes labelled, %(aria-labelledby="t")
    refute_includes labelled, %(aria-label="Command palette")
  end

  def test_command_dialog_rejects_the_old_aria_label_kwarg
    error = assert_raises(ArgumentError) { PhlexKit::CommandDialogContent.new(aria_label: "x") }
    assert_match(/aria: \{ label:/, error.message)
  end
end

# Sidebar's side: (0.16.0) — logical values, so a bare sidebar follows the
# reading direction instead of being physically left-pinned.
class SidebarSideTest < Minitest::Test
  include RenderHelper

  def test_default_side_is_start_and_adds_no_modifier
    html = render(PhlexKit::SidebarWrapper.new) { "x" }
    assert_includes html, "pk-sidebar-wrapper"
    refute_includes html, "side-end"
  end

  def test_side_end_stamps_the_modifier
    html = render(PhlexKit::SidebarWrapper.new(side: :end)) { "x" }
    assert_includes html, "side-end"
  end

  def test_side_end_survives_a_collapsible_wrapper
    html = render(PhlexKit::SidebarWrapper.new(side: :end, collapsible: :offcanvas)) { "x" }
    assert_includes html, "side-end"
    assert_includes html, "collapsible-offcanvas"
  end

  # Physical spellings are NOT the contract here — fail loud rather than
  # silently ignoring side: :left.
  def test_unknown_side_raises_naming_the_valid_keys
    error = assert_raises(KeyError) { render(PhlexKit::SidebarWrapper.new(side: :left)) { "x" } }
    assert_match(/unknown side :left/, error.message)
    assert_match(/:start/, error.message)
  end
end
