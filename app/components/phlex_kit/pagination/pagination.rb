module PhlexKit
  # Page navigation. Ported from ruby_ui's RubyUI::Pagination. Compose Pagination >
  # PaginationContent > PaginationItem(href:, active:) / PaginationEllipsis.
  class Pagination < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      nav(**mix({ class: "pk-pagination", role: "navigation", aria: { label: "pagination" } }, @attrs), &)
    end
  end
end
