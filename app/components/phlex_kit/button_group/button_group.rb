module PhlexKit
  # Joined row (or column) of buttons, ported from shadcn/ui's ButtonGroup:
  # children lose their inner corners/double borders and read as one segmented
  # control. `orientation: :vertical` stacks. Nest groups to separate segments
  # with a gap; add ButtonGroupText for static labels and ButtonGroupSeparator
  # between same-fill buttons. `.pk-button-group` (button_group.css).
  class ButtonGroup < BaseComponent
    ORIENTATIONS = { horizontal: nil, vertical: "vertical" }.freeze

    def initialize(orientation: :horizontal, **attrs)
      @orientation = orientation.to_sym
      @attrs = attrs
    end

    def view_template(&)
      classes = [ "pk-button-group", fetch_option(ORIENTATIONS, @orientation, :orientation) ].compact.join(" ")
      div(**mix({ class: classes, role: "group" }, @attrs), &)
    end
  end
end
