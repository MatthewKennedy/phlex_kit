module PhlexKit
  # "Next" control (label + chevron, label hidden on small screens), ported
  # from shadcn/ui's PaginationNext. Renders its own <li>. See pagination.rb.
  class PaginationNext < BaseComponent
    DEFAULT_LABEL = "Next"

    def initialize(href: "#", label: DEFAULT_LABEL, **attrs)
      @href = href
      @label = label
      @attrs = attrs
    end

    def view_template
      # The English aria-label only accompanies the default English label; a
      # custom (possibly localized) label: speaks for itself — hardcoding
      # "Go to next page" over it would make AT announce the wrong language.
      base = { href: @href, class: "pk-button ghost pk-pagination-next" }
      base[:aria] = { label: "Go to next page" } if @label == DEFAULT_LABEL
      li do
        a(**mix(base, @attrs)) do
          span(class: "pk-pagination-label") { @label }
          render Icon.new(:chevron_right, size: nil)
        end
      end
    end
  end
end
