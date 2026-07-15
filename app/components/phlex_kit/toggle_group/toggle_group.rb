module PhlexKit
  # A set of related toggles (single- or multi-select). Ported from ruby_ui's
  # RubyUI::ToggleGroup. Yields itself so items are declared with the group's
  # shared context: ToggleGroup(type:) { |g| g.ToggleGroupItem(value:) { … } }.
  class ToggleGroup < BaseComponent
    VALID_TYPES = %i[single multiple].freeze

    def initialize(type: :single, name: nil, value: nil, variant: :default, size: :default,
                   disabled: false, spacing: 0, orientation: :horizontal, **attrs)
      @type = type.to_sym
      raise ArgumentError, "type must be :single or :multiple" unless VALID_TYPES.include?(@type)
      @name = name
      @value = value
      @variant = variant.to_sym
      @size = size.to_sym
      @disabled = disabled
      @spacing = spacing.to_i
      @orientation = orientation.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix(group_default_attrs, @attrs)) do
        yield(self)
        render_hidden_inputs
      end
    end

    def item_context
      { type: @type, variant: @variant, size: @size, disabled: @disabled,
        selected_values: selected_values, spacing: @spacing, orientation: @orientation }
    end

    def ToggleGroupItem(**kwargs, &block)
      render PhlexKit::ToggleGroupItem.new(group_context: item_context, **kwargs), &block
    end

    private

    def selected_values
      case @type
      when :single then @value.nil? ? [] : [ @value.to_s ]
      when :multiple then Array(@value).map(&:to_s)
      end
    end

    def render_hidden_inputs
      return unless @name
      if @type == :single
        input(type: "hidden", name: @name, value: selected_values.first.to_s, data: { phlex_kit__toggle_group_target: "input" })
      else
        selected_values.each { |v| input(type: "hidden", name: "#{@name}[]", value: v, data: { phlex_kit__toggle_group_target: "input" }) }
      end
    end

    def group_default_attrs
      attrs = { role: (@type == :single) ? "radiogroup" : "group",
        class: [ "pk-toggle-group", (@orientation == :vertical ? "vertical" : nil), (@spacing > 0 ? "spaced" : nil) ].compact.join(" "),
        data: { controller: "phlex-kit--toggle-group",
          phlex_kit__toggle_group_type_value: @type.to_s,
          phlex_kit__toggle_group_name_value: @name.to_s,
          orientation: @orientation.to_s, spacing: @spacing.to_s } }
      # spacing: N gaps the items by N × .25rem (Tailwind-style scale) via the
      # custom property toggle_group.css reads. Trailing ";" so a caller
      # style: merges into a second valid declaration (Phlex mix gotcha).
      attrs[:style] = "--pk-toggle-group-gap: #{@spacing * 0.25}rem;" if @spacing > 0
      attrs
    end
  end
end
