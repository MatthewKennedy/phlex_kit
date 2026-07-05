# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class Fieldset < Phlex::HTML
        def view_template
          render PhlexKit::FieldSet.new(class: "w-sm") do
            render PhlexKit::FieldLegend.new { "Address Information" }
            render PhlexKit::FieldDescription.new { "We need your address to deliver your order." }
            render PhlexKit::FieldGroup.new do
              render PhlexKit::Field.new do
                render PhlexKit::FieldLabel.new(for: "fld-street") { "Street Address" }
                render PhlexKit::Input.new(id: "fld-street", placeholder: "123 Main St")
              end
              div(style: "display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;") do
                render PhlexKit::Field.new do
                  render PhlexKit::FieldLabel.new(for: "fld-city") { "City" }
                  render PhlexKit::Input.new(id: "fld-city", placeholder: "New York")
                end
                render PhlexKit::Field.new do
                  render PhlexKit::FieldLabel.new(for: "fld-zip") { "Postal Code" }
                  render PhlexKit::Input.new(id: "fld-zip", placeholder: "90502")
                end
              end
            end
          end
        end
      end
    end
  end
end
