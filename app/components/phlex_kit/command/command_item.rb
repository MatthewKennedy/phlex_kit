module PhlexKit
  # One palette result — an <a> (pass `href:`) filtered by `value:`, activated
  # by click or enter. aria-selected is toggled by keyboard navigation.
  # `disabled: true` renders the [data-disabled] styling + aria-disabled and
  # the controller skips it during keyboard navigation (matches
  # ContextMenuItem's pattern). See command.rb.
  class CommandItem < BaseComponent
    def initialize(value:, text: "", href: "#", disabled: false, **attrs)
      @value = value
      @text = text
      @href = href
      @disabled = disabled
      @attrs = attrs
    end

    def view_template(&)
      a(**mix({
        class: "pk-command-item",
        href: @href,
        role: "option",
        aria: { disabled: (@disabled ? "true" : nil) },
        data: {
          phlex_kit__command_target: "item",
          value: @value,
          text: @text,
          disabled: (@disabled ? "true" : nil),
          # Guards the default href="#": without it a mouse click (or the
          # Enter-synthesized click()) scrolls to top and appends # to the URL.
          action: "click->phlex-kit--command#onItemClick"
        }
      }, @attrs), &)
    end
  end
end
