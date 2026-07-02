module PhlexKit
  # Muted text inside an InputGroupAddon (e.g. a unit or prefix). See input_group.rb.
  class InputGroupText < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = span(**mix({ class: "pk-input-group-text" }, @attrs), &)
  end
end
