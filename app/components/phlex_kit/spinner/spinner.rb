module PhlexKit
  # Loading spinner, ported from shadcn/ui's Spinner (a spinning loader icon;
  # not in ruby_ui). Sizes via SIZES.fetch. `.pk-spinner` (spinner.css).
  class Spinner < BaseComponent
    SIZES = { sm: "sm", md: nil, lg: "lg" }.freeze

    def initialize(size: :md, **attrs)
      @size = size.to_sym
      @attrs = attrs
    end

    def view_template
      svg(**mix({
        xmlns: "http://www.w3.org/2000/svg",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: [ "pk-spinner", SIZES.fetch(@size) ].compact.join(" "),
        role: "status",
        aria: { label: "Loading" }
      }, @attrs)) { |s| s.path(d: "M21 12a9 9 0 1 1-6.219-8.56") }
    end
  end
end
