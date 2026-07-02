module PhlexKit
  # The chevron that sits over the appearance:none <select> in PhlexKit::NativeSelect.
  # Mirrors ruby_ui's NativeSelectIcon: renders a default chevron SVG, or a
  # caller-supplied block in its place. The svg uses `currentColor`, so the icon
  # colour is driven by `.pk-native-select-icon`'s `color` token (native_select.css).
  class NativeSelectIcon < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: "pk-native-select-icon" }, @attrs)) do
        block ? yield : chevron
      end
    end

    private

    def chevron
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        "aria-hidden": "true"
      ) { |s| s.path(d: "m6 9 6 6 6-6") }
    end
  end
end
