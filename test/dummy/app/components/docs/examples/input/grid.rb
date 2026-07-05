# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Grid < Phlex::HTML
        def view_template
          render PhlexKit::FieldGroup.new(style: "display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; max-width: 24rem;") do
            render PhlexKit::Field.new do
              render PhlexKit::FieldLabel.new(for: "first-name") { "First Name" }
              render PhlexKit::Input.new(id: "first-name", placeholder: "Jordan")
            end
            render PhlexKit::Field.new do
              render PhlexKit::FieldLabel.new(for: "last-name") { "Last Name" }
              render PhlexKit::Input.new(id: "last-name", placeholder: "Lee")
            end
          end
        end
      end
    end
  end
end
