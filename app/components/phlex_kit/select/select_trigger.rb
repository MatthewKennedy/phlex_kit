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
      render Icon.new(:chevrons_up_down, size: nil, class: "pk-select-trigger-icon")
    end
  end
end
