module PhlexKit
  # A heading labelling a SelectGroup inside PhlexKit::SelectContent (e.g. "Fruits").
  # See select.rb.
  class SelectLabel < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      h3(**mix({ class: "pk-select-label" }, @attrs), &block)
    end
  end
end
