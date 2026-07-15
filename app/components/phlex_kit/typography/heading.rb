module PhlexKit
  # Heading, ported from ruby_ui's RubyUI::Heading. `level:` (1–6) picks the
  # element AND a default size; `as:` overrides the element; `size:` (1–9)
  # overrides the size on ruby_ui's scale (text-xs … text-5xl). Presentational;
  # attrs pass through via mix. Tailwind → vanilla `.pk-heading*` (typography.css).
  class Heading < BaseComponent
    SIZES = %w[1 2 3 4 5 6 7 8 9].freeze
    # ruby_ui's level → default size mapping (h1 is big, h4 smaller); 5/6
    # extend the scale downward — HTML has h1–h6, so all six must map.
    LEVEL_SIZE = { "1" => "7", "2" => "6", "3" => "5", "4" => "4", "5" => "3", "6" => "2" }.freeze
    # `as:` is dispatched dynamically (send) — whitelist so it can't reach
    # arbitrary (including private) methods. Mirrors Separator/Marker.
    AS_TAGS = %i[h1 h2 h3 h4 h5 h6 p span div].freeze

    # level: defaults to 1 so `Heading.new` is identical to `Heading.new(level: 1)`
    # (a nil default used to render h1 with the level-6 size — self-disagreeing).
    def initialize(level: 1, as: nil, size: nil, **attrs)
      # Fail loud at construction: level 7 previously exploded at render time
      # with NoMethodError (no h7 element), and 5/6 fell through the size map.
      unless LEVEL_SIZE.key?(level.to_s)
        raise ArgumentError, "Invalid heading level: #{level.inspect} — valid: 1–6"
      end
      @level = level
      @as = as&.to_sym
      if @as && !AS_TAGS.include?(@as)
        raise ArgumentError, "unknown Heading as: #{@as.inspect} (use one of #{AS_TAGS.join(", ")})"
      end
      @size = size
      @attrs = attrs
    end

    def view_template(&block)
      send(element, **mix({ class: classes }, @attrs), &block)
    end

    private

    def element
      (@as || "h#{@level}").to_sym
    end

    def size_token
      token = (@size || LEVEL_SIZE.fetch(@level.to_s)).to_s
      raise ArgumentError, "Invalid heading size: #{token.inspect}" unless SIZES.include?(token)
      token
    end

    def classes
      "pk-heading pk-heading-#{size_token}"
    end
  end
end
