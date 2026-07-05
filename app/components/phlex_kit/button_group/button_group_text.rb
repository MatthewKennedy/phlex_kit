module PhlexKit
  # Static text segment inside a PhlexKit::ButtonGroup, ported from shadcn/ui's
  # ButtonGroupText — a muted, bordered cell that joins the group like a
  # button but isn't interactive. See button_group.rb.
  class ButtonGroupText < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-button-group-text" }, @attrs), &block)
    end
  end
end
