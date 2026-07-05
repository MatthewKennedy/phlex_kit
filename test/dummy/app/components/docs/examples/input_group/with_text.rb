# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class WithText < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 1.5rem") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::InputGroupText.new { "$" }
              end
              render PhlexKit::Input.new(placeholder: "0.00")
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::InputGroupText.new { "USD" }
              end
            end
            render PhlexKit::InputGroup.new do
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::InputGroupText.new { "https://" }
              end
              render PhlexKit::Input.new(placeholder: "example.com")
            end
          end
        end
      end
    end
  end
end
