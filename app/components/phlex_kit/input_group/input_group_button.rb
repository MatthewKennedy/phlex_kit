module PhlexKit
  # Small button inside an InputGroupAddon, ported from shadcn/ui's
  # InputGroupButton — a ghost xs Button tuned to sit flush in the shell
  # (tighter radius, no shadow). Same knobs as Button (variant:/size:/icon:),
  # defaulting to variant: :ghost, size: :xs. See input_group.rb.
  class InputGroupButton < BaseComponent
    def initialize(variant: :ghost, size: :xs, icon: false, **attrs)
      @variant = variant
      @size = size
      @icon = icon
      @attrs = attrs
    end

    def view_template(&block)
      render Button.new(variant: @variant, size: @size, icon: @icon, **mix({ class: "pk-input-group-button" }, @attrs), &block)
    end
  end
end
