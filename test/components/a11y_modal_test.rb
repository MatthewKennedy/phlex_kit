# frozen_string_literal: true

require "test_helper"

# A11y contract for the modal overlays: sheet/drawer panels declare the dialog
# role (the sheet-content controller supplies the behavior — focus trap,
# Escape, scroll lock, aria-labelledby); DialogContent accepts explicit
# labelledby:/describedby: ids for its accessible name.
class A11yModalTest < Minitest::Test
  include RenderHelper

  def test_sheet_content_declares_modal_dialog_semantics
    html = render(PhlexKit::SheetContent.new { "body" })
    assert_includes html, %(role="dialog")
    assert_includes html, %(aria-modal="true")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(data-phlex-kit--sheet-content-target="panel")
    assert_includes html, "keydown->phlex-kit--sheet-content#keydown"
    assert_includes html, "data-pk-overlay-clone"
    assert_includes html, "mousedown->phlex-kit--sheet-content#overlayMousedown"
  end

  def test_drawer_content_declares_modal_dialog_semantics
    html = render(PhlexKit::DrawerContent.new { "body" })
    assert_includes html, %(role="dialog")
    assert_includes html, %(aria-modal="true")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(data-phlex-kit--sheet-content-target="panel")
    assert_includes html, "keydown->phlex-kit--sheet-content#keydown"
    # drawer_content.rb hand-duplicates sheet_content.rb's clone-root markup
    # (same phlex-kit--sheet-content controller) — the marker and backdrop
    # guard below must be kept in sync with sheet_content.rb, not skipped.
    assert_includes html, "data-pk-overlay-clone"
    assert_includes html, "mousedown->phlex-kit--sheet-content#overlayMousedown"
  end

  def test_dialog_content_accepts_labelledby_and_describedby
    html = render(PhlexKit::DialogContent.new(labelledby: "t1", describedby: "d1") { "body" })
    assert_includes html, %(aria-labelledby="t1")
    assert_includes html, %(aria-describedby="d1")
  end

  def test_dialog_content_omits_aria_attributes_by_default
    html = render(PhlexKit::DialogContent.new { "body" })
    refute_includes html, "aria-labelledby"
    refute_includes html, "aria-describedby"
  end
end
