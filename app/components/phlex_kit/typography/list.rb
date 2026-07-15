module PhlexKit
  # Prose list, ported from shadcn/ui's typography "list" style (ruby_ui's
  # TypographyList). Renders a ul (or ol via as:) with the .pk-list styling
  # that previously shipped as an orphaned utility class. Children are plain
  # <li>s.
  class List < BaseComponent
    # `as:` is dispatched dynamically (send) — whitelist like Separator.
    AS_TAGS = %i[ul ol].freeze

    def initialize(as: :ul, **attrs)
      @as = as.to_sym
      unless AS_TAGS.include?(@as)
        raise ArgumentError, "unknown List as: #{@as.inspect} (use one of #{AS_TAGS.join(", ")})"
      end
      @attrs = attrs
    end

    def view_template(&)
      send(@as, **mix({ class: "pk-list" }, @attrs), &)
    end
  end
end
