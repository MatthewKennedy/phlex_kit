module PhlexKit
  # Hairline divider between same-fill segments of a PhlexKit::ButtonGroup,
  # ported from shadcn/ui's ButtonGroupSeparator. Runs perpendicular to the
  # group's orientation automatically (button_group.css). See button_group.rb.
  class ButtonGroupSeparator < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      # Purely decorative — aria-hidden only (role="separator" would
      # contradict aria-hidden and confuse AT).
      div(**mix({ class: "pk-button-group-separator", aria: { hidden: true } }, @attrs))
    end
  end
end
