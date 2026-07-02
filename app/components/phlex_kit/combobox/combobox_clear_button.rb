module PhlexKit
  # × button clearing the whole combobox selection — hidden until something is
  # checked. Ported from ruby_ui's RubyUI::ComboboxClearButton; upstream
  # referenced a clearAll action its controller never defined, so the behaviour
  # is PhlexKit's completion of it. See combobox.rb.
  class ComboboxClearButton < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      button(**mix({
        type: :button,
        class: "pk-combobox-clear-button pk-hidden",
        aria: { label: "Clear selection" },
        data: {
          phlex_kit__combobox_target: "clearButton",
          action: "phlex-kit--combobox#clearAll"
        }
      }, @attrs)) do
        svg(
          xmlns: "http://www.w3.org/2000/svg",
          width: "24",
          height: "24",
          viewbox: "0 0 24 24",
          fill: "none",
          stroke: "currentColor",
          "stroke-width": "2",
          "stroke-linecap": "round",
          "stroke-linejoin": "round",
          "aria-hidden": "true"
        ) do |s|
          s.path(d: "M18 6 6 18")
          s.path(d: "m6 6 12 12")
        end
      end
    end
  end
end
