# frozen_string_literal: true

module Docs
  module Examples
    module Select
      class Default < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Select.new do
              render PhlexKit::SelectInput.new(name: "fruit", id: "docs-fruit")
              render PhlexKit::SelectTrigger.new do
                render PhlexKit::SelectValue.new(placeholder: "Select a fruit")
              end
              render PhlexKit::SelectContent.new do
                render PhlexKit::SelectGroup.new do
                  render PhlexKit::SelectLabel.new { "Fruits" }
                  render PhlexKit::SelectItem.new(value: "apple") { "Apple" }
                  render PhlexKit::SelectItem.new(value: "banana") { "Banana" }
                  render PhlexKit::SelectItem.new(value: "blueberry") { "Blueberry" }
                  render PhlexKit::SelectItem.new(value: "grapes") { "Grapes" }
                end
              end
            end
          end
        end
      end
    end
  end
end
