module PhlexKit
  # Input with attached addons, ported from shadcn/ui's InputGroup: a bordered
  # shell that focuses as one control; compose InputGroupAddon(align:) around a
  # plain PhlexKit::Input (its own border/bg collapse inside the group).
  # `.pk-input-group*` (input_group.css).
  class InputGroup < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-input-group", role: "group" }, @attrs), &)
    end
  end
end
