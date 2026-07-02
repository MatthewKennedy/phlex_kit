module PhlexKit
  # Visual/semantic divider, ported from ruby_ui's RubyUI::Separator. `as:` picks
  # the element (div/hr), `orientation:` is horizontal (default) or vertical, and
  # `decorative:` toggles the a11y role (none vs separator). Presentational; attrs
  # pass through via `mix`. A bad orientation fails loud (ArgumentError), mirroring
  # the kit's fail-loud selectors.
  class Separator < BaseComponent
    ORIENTATIONS = %i[horizontal vertical].freeze

    def initialize(as: :div, orientation: :horizontal, decorative: true, **attrs)
      @as = as
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
