module PhlexKit
  # The closed-state button for PhlexKit::Combobox — shows the placeholder until the
  # controller writes the selected item text (or "N <term>") into the content
  # span. See combobox.rb.
  class ComboboxTrigger < BaseComponent
    def initialize(placeholder: "", **attrs)
      @placeholder = placeholder
      @attrs = attrs
    end

    def view_template
      button(**mix({
        type: :button,
        class: "pk-combobox-trigger",
        aria: { haspopup: "listbox", expanded: "false" },
        data: {
          placeholder: @placeholder,
          phlex_kit__combobox_target: "trigger",
          action: "phlex-kit--combobox#togglePopover"
        }
      }, @attrs)) do
        span(class: "pk-combobox-trigger-content", data: { phlex_kit__combobox_target: "triggerContent" }) do
          @placeholder
        end
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
        class: "pk-combobox-trigger-icon",
        "aria-hidden": "true"
      ) do |s|
        s.path(d: "m7 15 5 5 5-5")
        s.path(d: "m7 9 5-5 5 5")
      end
    end
  end
end
