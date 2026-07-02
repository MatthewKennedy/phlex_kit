module PhlexKit
  # The text shown in a PhlexKit::SelectTrigger — the selected item's label (yielded
  # block) or the `placeholder:` when nothing is chosen. The Stimulus controller
  # rewrites this element's text on selection. See select.rb.
  class SelectValue < BaseComponent
    def initialize(placeholder: nil, **attrs)
      @placeholder = placeholder
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: "pk-select-value", data: { phlex_kit__select_target: "value" } }, @attrs)) do
        if block
          yield
        elsif @placeholder
          plain @placeholder
        end
      end
    end
  end
end
