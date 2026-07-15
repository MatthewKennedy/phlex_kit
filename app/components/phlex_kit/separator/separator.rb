module PhlexKit
  # Visual/semantic divider, ported from ruby_ui's RubyUI::Separator. `as:` picks
  # the element (div/hr), `orientation:` is horizontal (default) or vertical, and
  # `decorative:` toggles the a11y role (none vs separator). Presentational; attrs
  # pass through via `mix`. A bad orientation fails loud (ArgumentError), mirroring
  # the kit's fail-loud selectors.
  class Separator < BaseComponent
    ORIENTATIONS = %i[horizontal vertical].freeze
    # `as:` is dispatched dynamically (send) — whitelist the documented
    # elements so it can't reach arbitrary (including private) methods.
    AS_TAGS = %i[div hr].freeze

    def initialize(as: :div, orientation: :horizontal, decorative: true, **attrs)
      @as = as.to_sym
      unless AS_TAGS.include?(@as)
        raise ArgumentError, "unknown Separator as: #{@as.inspect} (use one of #{AS_TAGS.join(", ")})"
      end
      @orientation = orientation.to_sym
      unless ORIENTATIONS.include?(@orientation)
        raise ArgumentError, "Invalid orientation: #{orientation.inspect}"
      end
      @decorative = decorative
      @attrs = attrs
    end

    def view_template(&block)
      send(@as, **mix({ role: (@decorative ? "none" : "separator"), class: classes }, @attrs), &block)
    end

    private

    def classes
      [ "pk-separator", @orientation.to_s ].join(" ")
    end
  end
end
