module PhlexKit
  class PaginationContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = ul(**mix({ class: "pk-pagination-content" }, @attrs), &)
  end
end
