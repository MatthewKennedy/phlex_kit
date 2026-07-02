module PhlexKit
  # Joined row of buttons, ported from shadcn/ui's ButtonGroup: children lose
  # their inner corners/double borders and read as one segmented control.
  # `.pk-button-group` (button_group.css).
  class ButtonGroup < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-button-group", role: "group" }, @attrs), &)
    end
  end
end
