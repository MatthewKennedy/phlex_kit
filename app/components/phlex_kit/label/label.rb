module PhlexKit
  # Standalone form label, ported from shadcn/ui's Label (FormFieldLabel is the
  # ruby_ui-shaped equivalent inside a FormField). Pass `for:` to bind it.
  # `.pk-label` (label.css).
  class Label < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      label(**mix({ class: "pk-label" }, @attrs), &)
    end
  end
end
