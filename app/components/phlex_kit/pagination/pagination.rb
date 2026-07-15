module PhlexKit
  # Page navigation. Ported from ruby_ui's RubyUI::Pagination. Compose Pagination >
  # PaginationContent > PaginationItem(href:, active:) / PaginationEllipsis.
  class Pagination < BaseComponent
    # label: is a named kwarg (not a mix default) because `mix` would *fuse* a
    # caller aria-label with the hardcoded "pagination" ("pagination Résultats").
    def initialize(label: "pagination", **attrs)
      @label = label
      @attrs = attrs
    end

    def view_template(&)
      base = { class: "pk-pagination", role: "navigation" }
      base[:aria] = { label: @label } unless aria_labelled?
      nav(**mix(base, @attrs), &)
    end

    private

    def aria_labelled?
      aria = @attrs[:aria] || @attrs["aria"]
      (aria.is_a?(Hash) && (aria[:label] || aria["label"])) ||
        [ :aria_label, "aria_label", "aria-label" ].any? { |k| @attrs[k] }
    end
  end
end
