# frozen_string_literal: true

require "test_helper"

# Task 16 — remaining render-test gaps: Table structural parts and the
# Breadcrumb parts whose accessibility contract (aria-current/role/
# aria-disabled, aria-hidden separator) wasn't exercised by any prior audit.
class Task16TableBreadcrumbTest < Minitest::Test
  include RenderHelper

  def test_table_head_renders_th_with_class
    html = render(PhlexKit::TableHead.new { "Name" })
    assert_includes html, "<th"
    assert_includes html, "pk-table-head"
    assert_includes html, "Name"
  end

  def test_table_cell_renders_td_with_class
    html = render(PhlexKit::TableCell.new { "Ada" })
    assert_includes html, "<td"
    assert_includes html, "pk-table-cell"
    assert_includes html, "Ada"
  end

  def test_table_row_renders_tr_with_class
    html = render(PhlexKit::TableRow.new { "x" })
    assert_includes html, "<tr"
    assert_includes html, "pk-table-row"
  end

  def test_table_body_renders_tbody_with_class
    html = render(PhlexKit::TableBody.new { "x" })
    assert_includes html, "<tbody"
    assert_includes html, "pk-table-body"
  end

  def test_table_header_renders_thead_with_class
    html = render(PhlexKit::TableHeader.new { "x" })
    assert_includes html, "<thead"
    assert_includes html, "pk-table-header"
  end

  def test_table_parts_merge_caller_attrs_not_clobber
    html = render(PhlexKit::TableHead.new(class: "extra", scope: "col") { "Name" })
    assert_includes html, "pk-table-head"
    assert_includes html, "extra"
    assert_includes html, %(scope="col")
  end

  def test_breadcrumb_page_has_link_role_current_page_and_aria_disabled
    html = render(PhlexKit::BreadcrumbPage.new { "Settings" })
    assert_includes html, %(role="link")
    assert_includes html, %(aria-current="page")
    assert_includes html, "aria-disabled"
    assert_includes html, "Settings"
    # It's a span, not an anchor — the current page isn't itself a link.
    assert_includes html, "<span"
    refute_includes html, "<a "
  end

  def test_breadcrumb_page_caller_attrs_merge
    html = render(PhlexKit::BreadcrumbPage.new(class: "extra") { "Settings" })
    assert_includes html, "pk-breadcrumb-page"
    assert_includes html, "extra"
  end

  def test_breadcrumb_separator_is_presentational_and_hidden
    html = render(PhlexKit::BreadcrumbSeparator.new)
    assert_includes html, "<li"
    assert_includes html, %(role="presentation")
    assert_includes html, %(aria-hidden="true")
  end

  def test_breadcrumb_separator_default_renders_chevron_icon
    html = render(PhlexKit::BreadcrumbSeparator.new)
    assert_includes html, "pk-icon"
  end

  def test_breadcrumb_separator_accepts_custom_block
    html = render(PhlexKit::BreadcrumbSeparator.new { "/" })
    assert_includes html, "/"
    refute_includes html, "pk-icon"
  end
end
