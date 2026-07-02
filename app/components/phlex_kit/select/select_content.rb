module PhlexKit
  # The dropdown panel for PhlexKit::Select — hidden until the trigger opens it (the
  # controller toggles the `hidden` class). Outer div is the positioned/targeted
  # layer; the inner `.pk-select-viewport` is the bordered, scrollable box.
  # Holds SelectGroup / SelectLabel / SelectItem children. See select.rb.
  class SelectContent < BaseComponent
    def initialize(**attrs)
      @id = "pk-select-content-#{SecureRandom.hex(4)}"
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        id: @id,
        role: "listbox",
        tabindex: "-1",
        class: "pk-select-content hidden",
        data: { phlex_kit__select_target: "content" }
      }, @attrs)) do
        div(class: "pk-select-viewport", &block)
      end
    end
  end
end
