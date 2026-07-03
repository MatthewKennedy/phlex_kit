module PhlexKit
  class PaginationEllipsis < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      li do
        span(**mix({ class: "pk-pagination-ellipsis", aria: { hidden: true } }, @attrs)) do
          render Icon.new(:ellipsis, size: nil)
          span(class: "pk-sr-only") { "More pages" }
        end
      end
    end
  end
end
