module PhlexKit
  # Toggle for a Collapsible. Renders a plain wrapper carrying the click
  # action — it deliberately has no role of its own, so nest a real focusable
  # control (a <button>, e.g. PhlexKit::Button) inside it for keyboard
  # operability and semantics, the same composition pattern as
  # AttachmentTrigger. Pass `open:` matching the parent Collapsible's so
  # aria-expanded is correct before JS; the controller keeps it in sync and
  # wires aria-controls to the content's id in connect().
  class CollapsibleTrigger < BaseComponent
    def initialize(open: false, **attrs)
      @open = open
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-collapsible-trigger",
        aria_expanded: @open ? "true" : "false",
        data: { phlex_kit__collapsible_target: "trigger", action: "click->phlex-kit--collapsible#toggle" }
      }, @attrs), &)
    end
  end
end
