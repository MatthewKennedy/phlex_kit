module PhlexKit
  # "No results" placeholder — hidden until filtering empties the list.
  # See combobox.rb.
  class ComboboxEmptyState < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        role: "presentation",
        class: "pk-combobox-empty pk-hidden",
        data: { phlex_kit__combobox_target: "emptyState" }
      }, @attrs), &)
    end
  end
end
