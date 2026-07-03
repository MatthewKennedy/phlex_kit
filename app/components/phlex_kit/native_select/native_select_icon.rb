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
      render Icon.new(:chevron_down, size: nil)
    end
  end
end
