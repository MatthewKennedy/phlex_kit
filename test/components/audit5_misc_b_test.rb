# frozen_string_literal: true

require "test_helper"

# Audit round 5 (batch B) — nit fixes + render-test gap closures for
# pagination, tabs, table caption/footer, and typography inlines.
class Audit5MiscBTest < Minitest::Test
  include RenderHelper

  # --- Nit 2: Separator `as:` is dispatched via send — must be allowlisted.
  def test_separator_unknown_as_fails_loud
    error = assert_raises(ArgumentError) { PhlexKit::Separator.new(as: :script) }
    assert_match(/as/i, error.message)
  end

  def test_separator_allows_div_and_hr
    assert_includes render(PhlexKit::Separator.new), "<div"
    assert_includes render(PhlexKit::Separator.new(as: :hr)), "<hr"
  end

  # --- Nit 3: Marker `as:` must not silently fall through to div.
  def test_marker_unknown_as_fails_loud
    error = assert_raises(ArgumentError) { PhlexKit::Marker.new(as: :span) }
    assert_match(/as/i, error.message)
  end

  def test_marker_as_button_and_default_div
    assert_match(/<button[^>]+class="pk-marker"/, render(PhlexKit::Marker.new(as: :button) { "x" }))
    assert_match(/<div[^>]+class="pk-marker"/, render(PhlexKit::Marker.new { "x" }))
  end

  # --- Nit 4: Heading's no-arg default must be identical to level: 1
  # (previously no-arg rendered h1 with pk-heading-6 while level: 1 gave -7).
  def test_heading_no_arg_default_matches_level_one
    assert_equal render(PhlexKit::Heading.new(level: 1) { "T" }),
                 render(PhlexKit::Heading.new { "T" })
    assert_includes render(PhlexKit::Heading.new { "T" }), "pk-heading-7"
  end

  # --- Nit 5: PaginationNext/Previous drop the hardcoded English aria-label
  # when a custom (possibly localized) label: is passed.
  def test_pagination_next_default_keeps_english_aria_label
    html = render(PhlexKit::PaginationNext.new)
    assert_includes html, %(aria-label="Go to next page")
    assert_includes html, ">Next</span>"
  end

  def test_pagination_next_custom_label_drops_hardcoded_aria_label
    html = render(PhlexKit::PaginationNext.new(label: "Suivant"))
    refute_includes html, "aria-label"
    assert_includes html, ">Suivant</span>"
  end

  def test_pagination_previous_default_keeps_english_aria_label
    html = render(PhlexKit::PaginationPrevious.new)
    assert_includes html, %(aria-label="Go to previous page")
    assert_includes html, ">Previous</span>"
  end

  def test_pagination_previous_custom_label_drops_hardcoded_aria_label
    html = render(PhlexKit::PaginationPrevious.new(label: "Précédent"))
    refute_includes html, "aria-label"
    assert_includes html, ">Précédent</span>"
  end

  def test_pagination_next_custom_label_still_accepts_caller_aria_label
    html = render(PhlexKit::PaginationNext.new(label: "Suivant", aria: { label: "Page suivante" }))
    assert_includes html, %(aria-label="Page suivante")
  end

  # --- Gap 7: pagination family render tests.
  def test_pagination_root
    html = render(PhlexKit::Pagination.new)
    assert_match(/<nav[^>]+class="pk-pagination"/, html)
    assert_includes html, %(role="navigation")
    assert_includes html, %(aria-label="pagination")
  end

  def test_pagination_content
    assert_match(/<ul[^>]+class="pk-pagination-content"/, render(PhlexKit::PaginationContent.new))
  end

  def test_pagination_link_active
    html = render(PhlexKit::PaginationLink.new(href: "/p/2", active: true) { "2" })
    assert_includes html, "<li>"
    assert_includes html, %(href="/p/2")
    assert_includes html, "pk-button outline icon"
    assert_includes html, %(aria-current="page")
  end

  def test_pagination_link_inactive
    html = render(PhlexKit::PaginationLink.new(href: "/p/3") { "3" })
    assert_includes html, "pk-button ghost icon"
    refute_includes html, "aria-current"
  end

  def test_pagination_next_and_previous_render_li_with_chevron
    next_html = render(PhlexKit::PaginationNext.new(href: "/p/4"))
    assert_includes next_html, "<li>"
    assert_includes next_html, "pk-pagination-next"
    assert_includes next_html, "<svg"
    prev_html = render(PhlexKit::PaginationPrevious.new(href: "/p/1"))
    assert_includes prev_html, "pk-pagination-previous"
    assert_includes prev_html, "<svg"
  end

  # --- Gap 8: Tabs root + TabsList.
  def test_tabs_root_controller_wiring
    html = render(PhlexKit::Tabs.new(default: "account"))
    assert_includes html, "pk-tabs"
    assert_includes html, %(data-controller="phlex-kit--tabs")
    assert_includes html, %(data-phlex-kit--tabs-active-value="account")
  end

  def test_tabs_orientation_variant_and_fail_loud
    assert_includes render(PhlexKit::Tabs.new(orientation: :vertical)), "pk-tabs vertical"
    assert_raises(KeyError) { render(PhlexKit::Tabs.new(orientation: :diagonal)) }
  end

  def test_tabs_list
    html = render(PhlexKit::TabsList.new)
    assert_includes html, "pk-tabs-list"
    assert_includes html, %(role="tablist")
    assert_includes html, %(data-phlex-kit--tabs-target="list")
    assert_includes html, "phlex-kit--tabs#keydown"
  end

  def test_tabs_list_variant_and_fail_loud
    assert_includes render(PhlexKit::TabsList.new(variant: :line)), "pk-tabs-list line"
    assert_raises(KeyError) { render(PhlexKit::TabsList.new(variant: :dashed)) }
  end

  # --- Gap 9: table caption/footer.
  def test_table_caption
    assert_match(/<caption[^>]+class="pk-table-caption"/, render(PhlexKit::TableCaption.new { "A list" }))
  end

  def test_table_footer
    assert_match(/<tfoot[^>]+class="pk-table-footer"/, render(PhlexKit::TableFooter.new))
  end

  # --- Gap 10: typography inlines.
  def test_blockquote
    assert_match(/<blockquote[^>]+class="pk-blockquote"/, render(PhlexKit::Blockquote.new { "Q" }))
  end

  def test_inline_code
    assert_match(/<code[^>]+class="pk-inline-code"/, render(PhlexKit::InlineCode.new { "puts" }))
  end

  def test_inline_link
    html = render(PhlexKit::InlineLink.new(href: "/docs") { "Docs" })
    assert_match(/<a[^>]+class="pk-inline-link"/, html)
    assert_includes html, %(href="/docs")
  end
end
