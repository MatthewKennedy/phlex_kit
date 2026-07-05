module PhlexKit
  # Hairline between SelectGroups, ported from shadcn/ui's SelectSeparator.
  # See select.rb.
  class SelectSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      div(**mix({ class: "pk-select-separator", role: "separator", aria: { hidden: true } }, @attrs))
    end
  end
end
