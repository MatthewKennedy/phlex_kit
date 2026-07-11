module PhlexKit
  # Wrapper the panel anchors to. Carries no actions: the controller wires
  # the button inside it to the panel via popoverTargetElement, so the
  # browser owns toggling (mouse + keyboard). See popover.rb.
  class PopoverTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-popover-trigger", data: { phlex_kit__popover_target: "trigger" } }, @attrs), &)
    end
  end
end
