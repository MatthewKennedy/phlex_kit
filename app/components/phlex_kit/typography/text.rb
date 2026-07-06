module PhlexKit
  # Body text, ported from ruby_ui's RubyUI::Text. `as:` picks the element
  # (default :p), `size:` (1–9 or xs/sm/base/lg/xl/2xl…) the size, `weight:` the
  # font-weight — plus ruby_ui's `:muted` "weight", which is really the muted
  # COLOR (a drop-in for the legacy `.muted` utility). Attrs pass through via mix.
  # `SIZES`/`WEIGHTS` fetch fails loud. Tailwind → vanilla `.pk-text*`.
  class Text < BaseComponent
    SIZES = {
      "1" => "1", "xs" => "1",
      "2" => "2", "sm" => "2",
      "3" => "3", "base" => "3",
      "4" => "4", "lg" => "4",
      "5" => "5", "xl" => "5",
      "6" => "6", "2xl" => "6",
      "7" => "7", "3xl" => "7",
      "8" => "8", "4xl" => "8",
      "9" => "9", "5xl" => "9"
    }.freeze

    # weight => modifier class (nil = regular). `:muted` is a colour, not a weight,
    # matching ruby_ui's API.
    WEIGHTS = {
      regular: nil,
      light: "pk-text-light",
      medium: "pk-text-medium",
      semibold: "pk-text-semibold",
      bold: "pk-text-bold",
      muted: "pk-text-muted"
    }.freeze

    def initialize(as: :p, size: "3", weight: :regular, **attrs)
      @as = as
      @size = size.to_s
      @weight = weight.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      send(@as, **mix({ class: classes }, @attrs), &block)
    end

    private

    def classes
      [ "pk-text", "pk-text-#{fetch_option(SIZES, @size, :size)}", fetch_option(WEIGHTS, @weight, :weight) ].compact.join(" ")
    end
  end
end
