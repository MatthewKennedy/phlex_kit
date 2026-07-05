# frozen_string_literal: true

module Docs
  module Examples
    module Select
      class Disabled < Phlex::HTML
        def view_template
          div(style: "width: 100%; max-width: 15rem;") do
            render PhlexKit::Select.new do
              render PhlexKit::SelectInput.new(name: "sel-disabled")
              render PhlexKit::SelectTrigger.new(disabled: true) do
                render PhlexKit::SelectValue.new(placeholder: "Select a fruit")
              end
              render PhlexKit::SelectContent.new do
                render PhlexKit::SelectItem.new(value: "apple") { "Apple" }
              end
            end
          end
        end
      end
    end
  end
end
