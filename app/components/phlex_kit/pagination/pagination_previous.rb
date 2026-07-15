module PhlexKit
  # "Previous" control (chevron + label, label hidden on small screens),
  # ported from shadcn/ui's PaginationPrevious. Renders its own <li>.
  # See pagination.rb.
  class PaginationPrevious < BaseComponent
    DEFAULT_LABEL = "Previous"

    def initialize(href: "#", label: DEFAULT_LABEL, **attrs)
      @href = href
      @label = label
      @attrs = attrs
    end

    def view_template
      # The English aria-label only accompanies the default English label; a
      # custom (possibly localized) label: speaks for itself — hardcoding
      # "Go to previous page" over it would make AT announce the wrong language.
      base = { href: @href, class: "pk-button ghost pk-pagination-previous" }
      # ...and never over a caller-supplied aria label — `mix` would fuse
      # the two strings instead of overriding.
      base[:aria] = { label: "Go to previous page" } if @label == DEFAULT_LABEL && !aria_labelled?
      li do
        a(**mix(base, @attrs)) do
          render Icon.new(:chevron_left, size: nil)
          span(class: "pk-pagination-label") { @label }
        end
      end
    end

    private

    def aria_labelled?
      aria = @attrs[:aria] || @attrs["aria"]
      (aria.is_a?(Hash) && (aria[:label] || aria["label"])) ||
        [ :aria_label, "aria_label", "aria-label" ].any? { |k| @attrs[k] }
    end
  end
end
