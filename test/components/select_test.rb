# frozen_string_literal: true

require "test_helper"

# Audit fixes for PhlexKit::Select: the document-scoped `.pk-select-item`
# outlet let one select clobber aria-selected in every other select on the
# page, and reading `event.target` (instead of currentTarget) wrote the
# string "undefined" into the hidden input when a child element was clicked.
# The fix drops the outlet + per-item controller; selection is flipped via
# the instance-scoped itemTargets.
class SelectTest < Minitest::Test
  include RenderHelper

  def test_root_has_no_document_scoped_item_outlet
    html = render(PhlexKit::Select.new)
    refute_includes html, "outlet"
    assert_includes html, %(data-controller="phlex-kit--select")
  end

  def test_item_does_not_register_its_own_controller
    html = render(PhlexKit::SelectItem.new(value: "admin") { "Admin" })
    refute_includes html, "phlex-kit--select-item"
    assert_includes html, %(data-phlex-kit--select-target="item")
    assert_includes html, %(data-value="admin")
  end

  def test_item_selected_kwarg_still_renders_aria_selected
    html = render(PhlexKit::SelectItem.new(value: "admin", selected: true) { "Admin" })
    assert_includes html, %(aria-selected="true")
  end
end
