module PhlexKit
  class ToggleGroupItem < Toggle
    def initialize(value:, group_context:, variant: nil, size: nil, **attrs)
      # Toggle kwargs this item renders no markup for, or that the group
      # derives itself (pressed: comes from the group's selected_values) —
      # inheriting them silently discarded the caller's input.
      unsupported = attrs.keys & %i[wrapper name unpressed_value pressed]
      if unsupported.any?
        raise ArgumentError, "ToggleGroupItem does not support #{unsupported.join(", ")} (group items render a bare button)"
      end
      @item_value = value.to_s
      @group_context = group_context
      pressed = group_context[:selected_values].include?(@item_value)
      item_disabled = attrs.key?(:disabled) ? attrs.delete(:disabled) : group_context[:disabled]
      # Roving tabindex initial stop: when nothing is selected yet, the first
      # enabled item claims tabindex="0" (see ToggleGroup#claim_tab_stop).
      # group_context[:group] is nil for a hand-built context (bypassing
      # ToggleGroup#item_context) — treat that as "no tab-stop claim" rather
      # than raising, since standalone tests construct contexts by hand.
      @is_first_tab_stop = group_context[:group]&.claim_tab_stop(item_disabled, pressed: pressed) || false
      super(pressed: pressed, name: nil, value: @item_value,
            variant: variant || group_context[:variant],
            size: size || group_context[:size],
            disabled: item_disabled, **attrs)
    end

    def view_template(&block)
      button(**mix(item_default_attrs, @attrs), &block)
    end

    private

    def item_default_attrs
      a = { type: :button,
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
        # When nothing is selected, the first enabled item claims the initial
        # roving-tabindex stop instead of every item defaulting to -1.
        a[:tabindex] = (@pressed && !@disabled) || @is_first_tab_stop ? "0" : "-1"
      else
        a[:aria] = { pressed: @pressed.to_s }
        a[:tabindex] = "0"
      end
      a
    end
  end
end
