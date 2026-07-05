# frozen_string_literal: true

module Docs
  module Examples
    module RadioGroup
      class Fieldset < Phlex::HTML
        OPTIONS = [
          [ "all", "All new messages", true ],
          [ "mentions", "Direct messages and mentions", false ],
          [ "none", "Nothing", false ]
        ].freeze

        def view_template
          render PhlexKit::FieldSet.new(class: "w-sm") do
            render PhlexKit::FieldLegend.new(variant: :label) { "Notification method" }
            render PhlexKit::FieldDescription.new { "Choose how you want to be notified." }
            render PhlexKit::RadioGroup.new do
              OPTIONS.each do |value, text, checked|
                render PhlexKit::Field.new(orientation: :horizontal) do
                  render PhlexKit::RadioButton.new(id: "rg-notify-#{value}", name: "rg-notify", value: value, checked: checked)
                  render PhlexKit::FieldLabel.new(for: "rg-notify-#{value}", style: "font-weight: 400") { text }
                end
              end
            end
          end
        end
      end
    end
  end
end
