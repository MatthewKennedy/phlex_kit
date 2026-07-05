# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class WithSpinner < Phlex::HTML
        def view_template
          div(class: "stack w-sm") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(placeholder: "Searching...")
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::Spinner.new
              end
            end
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(placeholder: "Saving changes...")
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::InputGroupText.new { "Saving..." }
                render PhlexKit::Spinner.new
              end
            end
          end
        end
      end
    end
  end
end
