module PhlexKit
  class PaginationEllipsis < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      li do
        # No aria-hidden on the wrapper — it would swallow the sr-only text.
        # The Icon renders its own aria-hidden="true"; only the glyph is hidden.
        span(**mix({ class: "pk-pagination-ellipsis" }, @attrs)) do
          render Icon.new(:ellipsis, size: nil)
          span(class: "pk-sr-only") { "More pages" }
        end
      end
    end
  end
end
