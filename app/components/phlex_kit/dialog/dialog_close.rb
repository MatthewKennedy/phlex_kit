module PhlexKit
  # Wraps any element (typically a Button) so clicking it dismisses the
  # enclosing dialog, mirroring shadcn/ui's DialogClose. See dialog.rb.
  class DialogClose < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      span(**mix({ style: "display: contents;", data: { action: "click->phlex-kit--dialog#dismiss" } }, @attrs), &)
    end
  end
end
