# frozen_string_literal: true

module Docs
  module Examples
    module RadioGroup
      class Description < Phlex::HTML
        PLANS = [
          [ "starter", "Starter", "Perfect for small projects and personal use.", true ],
          [ "pro", "Pro", "Advanced features for growing teams.", false ]
        ].freeze

        def view_template
          render PhlexKit::RadioGroup.new(class: "w-sm", style: "gap: .75rem") do
            PLANS.each do |value, title, description, checked|
              render PhlexKit::Field.new(orientation: :horizontal) do
                render PhlexKit::RadioButton.new(id: "plan-#{value}", name: "rg-plan", value: value, checked: checked)
                render PhlexKit::FieldContent.new do
                  render PhlexKit::FieldLabel.new(for: "plan-#{value}") { title }
                  render PhlexKit::FieldDescription.new { description }
                end
              end
            end
          end
        end
      end
    end
  end
end
