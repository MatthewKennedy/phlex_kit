# frozen_string_literal: true

module Docs
  module Examples
    module RadioGroup
      class ChoiceCard < Phlex::HTML
        PLANS = [
          [ "monthly", "Monthly", "$9/month, billed monthly", false ],
          [ "yearly", "Yearly", "$90/year, two months free", true ]
        ].freeze

        def view_template
          # FieldLabel wrapping a Field = the choice-card recipe (highlights
          # while its radio is checked).
          render PhlexKit::RadioGroup.new(class: "w-sm", style: "gap: .75rem") do
            PLANS.each do |value, title, description, checked|
              render PhlexKit::FieldLabel.new(for: "rg-billing-#{value}") do
                render PhlexKit::Field.new(orientation: :horizontal) do
                  render PhlexKit::RadioButton.new(id: "rg-billing-#{value}", name: "rg-billing", value: value, checked: checked)
                  render PhlexKit::FieldContent.new do
                    render PhlexKit::FieldTitle.new { title }
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
end
