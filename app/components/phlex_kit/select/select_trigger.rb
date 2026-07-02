module PhlexKit
  # The closed-state button for PhlexKit::Select — shows the current SelectValue and a
  # up/down chevron, and opens the panel on click (`phlex-kit--select#onClick`).
  # See select.rb.
  class SelectTrigger < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      button(**mix({
        type: :button,
        role: "combobox",
        class: "pk-select-trigger",
        aria: { expanded: "false", haspopup: "listbox", autocomplete: "none" },
        data: { action: "phlex-kit--select#onClick", phlex_kit__select_target: "trigger" }
      }, @attrs)) do
        block&.call
        icon
      end
    end

    private

    def icon
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "pk-select-trigger-icon",
        "aria-hidden": "true"
      ) do |s|
        s.path(d: "m7 15 5 5 5-5")
        s.path(d: "m7 9 5-5 5 5")
      end
    end
  end
end
