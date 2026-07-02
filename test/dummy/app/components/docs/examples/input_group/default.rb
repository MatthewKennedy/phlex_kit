# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class Default < Phlex::HTML
        def view_template
          div(class: "stack w-md") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::InputGroupText.new { "https://" }
              end
              render PhlexKit::Input.new(placeholder: "example.com", name: "url")
            end
            render PhlexKit::InputGroup.new do
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::InputGroupText.new { "🔍" }
              end
              render PhlexKit::Input.new(placeholder: "Search…")
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::Spinner.new(size: :sm)
              end
            end
          end
        end
      end
    end
  end
end
