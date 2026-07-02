module PhlexKit
  # Groups a set of SelectItems (optionally under a SelectLabel) inside a
  # PhlexKit::SelectContent. Plain pass-through wrapper. See select.rb.
  class SelectGroup < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-select-group" }, @attrs), &block)
    end
  end
end
