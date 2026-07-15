module PhlexKit
  class ToggleGroupItem < Toggle
    def initialize(value:, group_context:, variant: nil, size: nil, **attrs)
      # Toggle kwargs this item renders no markup for — inheriting them
      # silently discarded the caller's input.
      unsupported = attrs.keys & %i[wrapper name unpressed_value]
      if unsupported.any?
        raise ArgumentError, "ToggleGroupItem does not support #{unsupported.join(", ")} (group items render a bare button)"
      end
      @item_value = value.to_s
      @group_context = group_context
      pressed = group_context[:selected_values].include?(@item_value)
      super(pressed: pressed, name: nil, value: @item_value,
            variant: variant || group_context[:variant],
            size: size || group_context[:size],
            disabled: group_context[:disabled], **attrs)
    end

    def view_template(&block)
      button(**mix(item_default_attrs, @attrs), &block)
    end

    private

    def item_default_attrs
      a = { type: "button",
            class: ([ "pk-toggle" ] + self.class.modifier_classes(variant: @variant, size: @size) + [ "pk-toggle-group-item" ]).join(" "),
            data: { state: @pressed ? "on" : "off", value: @item_value,
              phlex_kit__toggle_group_target: "item",
              action: "click->phlex-kit--toggle-group#select keydown->phlex-kit--toggle-group#navigate" } }
      a[:disabled] = true if @disabled
      if @group_context[:type] == :single
        a[:role] = "radio"
        a[:aria] = { checked: @pressed.to_s }
        # A disabled button can't take focus — giving the tab stop to a
        # pressed-but-disabled item made the whole group Tab-unreachable.
        a[:tabindex] = (@pressed && !@disabled) ? "0" : "-1"
      else
        a[:aria] = { pressed: @pressed.to_s }
        a[:tabindex] = "0"
      end
      a
    end
  end
end
