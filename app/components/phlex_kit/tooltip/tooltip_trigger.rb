module PhlexKit
  # The element a PhlexKit::Tooltip is anchored to. `tabindex: 0` so keyboard users can
  # focus it (the bubble shows on `:focus-within`) — pass `focusable: false` when
  # the trigger wraps something already focusable (a button, a link) so it
  # doesn't add a redundant tab stop. See tooltip.rb.
  class TooltipTrigger < BaseComponent
    def initialize(focusable: true, **attrs)
      @focusable = focusable
      @attrs = attrs
    end

    def view_template(&block)
      defaults = { class: "pk-tooltip-trigger" }
      defaults[:tabindex] = 0 if @focusable
      span(**mix(defaults, @attrs), &block)
    end
  end
end
