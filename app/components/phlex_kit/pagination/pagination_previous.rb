module PhlexKit
  # "Previous" control (chevron + label, label hidden on small screens),
  # ported from shadcn/ui's PaginationPrevious. Renders its own <li>.
  # See pagination.rb.
  class PaginationPrevious < BaseComponent
    def initialize(href: "#", label: "Previous", **attrs)
      @href = href
      @label = label
      @attrs = attrs
    end

    def view_template
      li do
        a(**mix({ href: @href, class: "pk-button ghost pk-pagination-previous", aria: { label: "Go to previous page" } }, @attrs)) do
          render Icon.new(:chevron_left, size: nil)
          span(class: "pk-pagination-label") { @label }
        end
      end
    end
  end
end
