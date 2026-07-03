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
      render Icon.new(:chevrons_up_down, size: nil, class: "pk-combobox-trigger-icon")
    end
  end
end
