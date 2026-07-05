# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Grid < Phlex::HTML
        def view_template
          div(style: "display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; width: 100%; max-width: 24rem;") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "first-name") { "First Name" }
              render PhlexKit::Input.new(id: "first-name", placeholder: "Jordan")
            end
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new(for: "last-name") { "Last Name" }
              render PhlexKit::Input.new(id: "last-name", placeholder: "Lee")
            end
          end
        end
      end
    end
  end
end
