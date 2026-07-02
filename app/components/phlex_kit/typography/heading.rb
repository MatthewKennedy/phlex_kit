module PhlexKit
  # Heading, ported from ruby_ui's RubyUI::Heading. `level:` (1–4) picks the
  # element AND a default size; `as:` overrides the element; `size:` (1–9)
  # overrides the size on ruby_ui's scale (text-xs … text-5xl). Presentational;
  # attrs pass through via mix. Tailwind → vanilla `.pk-heading*` (typography.css).
  class Heading < BaseComponent
    SIZES = %w[1 2 3 4 5 6 7 8 9].freeze
    # ruby_ui's level → default size mapping (h1 is big, h4 smaller).
    LEVEL_SIZE = { "1" => "7", "2" => "6", "3" => "5", "4" => "4" }.freeze

    def initialize(level: nil, as: nil, size: nil, **attrs)
      @level = level
      @as = as
      @size = size
      @attrs = attrs
    end

    def view_template(&block)
      send(element, **mix({ class: classes }, @attrs), &block)
    end

    private

    def element
      (@as || (@level ? "h#{@level}" : "h1")).to_sym
    end

    def size_token
      token = (@size || LEVEL_SIZE[@level.to_s] || "6").to_s
      raise ArgumentError, "Invalid heading size: #{token.inspect}" unless SIZES.include?(token)
      token
    end

    def classes
      "pk-heading pk-heading-#{size_token}"
    end
  end
end
