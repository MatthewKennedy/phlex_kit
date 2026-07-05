module PhlexKit
  # "Next" control (label + chevron, label hidden on small screens), ported
  # from shadcn/ui's PaginationNext. Renders its own <li>. See pagination.rb.
  class PaginationNext < BaseComponent
    def initialize(href: "#", label: "Next", **attrs)
      @href = href
      @label = label
      @attrs = attrs
    end

    def view_template
      li do
        a(**mix({ href: @href, class: "pk-button ghost pk-pagination-next", aria: { label: "Go to next page" } }, @attrs)) do
          span(class: "pk-pagination-label") { @label }
          render Icon.new(:chevron_right, size: nil)
        end
      end
    end
  end
end
