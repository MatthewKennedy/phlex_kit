# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class WithSelect < Phlex::HTML
        def view_template
          render PhlexKit::ButtonGroup.new do
            render PhlexKit::ButtonGroup.new do
              render PhlexKit::Select.new do
                render PhlexKit::SelectTrigger.new(style: "font-family: var(--pk-font-mono); width: fit-content;") do
                  render PhlexKit::SelectValue.new { "$" }
                end
                render PhlexKit::SelectContent.new do
                  render PhlexKit::SelectGroup.new do
                    render PhlexKit::SelectItem.new(value: "$", selected: true) { "$ US Dollar" }
                    render PhlexKit::SelectItem.new(value: "€") { "€ Euro" }
                    render PhlexKit::SelectItem.new(value: "£") { "£ British Pound" }
                  end
                end
              end
              render PhlexKit::Input.new(placeholder: "10.00")
            end
            render PhlexKit::ButtonGroup.new do
              render PhlexKit::Button.new(variant: :outline, icon: true, aria: { label: "Send" }) do
                render PhlexKit::Icon.new(:arrow_right, size: nil)
              end
            end
          end
        end
      end
    end
  end
end
