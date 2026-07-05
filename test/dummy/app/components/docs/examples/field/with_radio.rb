# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class WithRadio < Phlex::HTML
        PLANS = [
          [ "monthly", "Monthly ($9.99/month)", true ],
          [ "yearly", "Yearly ($99.99/year)", false ],
          [ "lifetime", "Lifetime ($299.99)", false ]
        ].freeze

        def view_template
          render PhlexKit::FieldSet.new(class: "w-sm") do
            render PhlexKit::FieldLegend.new(variant: :label) { "Subscription Plan" }
            render PhlexKit::FieldDescription.new { "Yearly and lifetime plans offer significant savings." }
            render PhlexKit::RadioGroup.new do
              PLANS.each do |value, text, checked|
                render PhlexKit::Field.new(orientation: :horizontal) do
                  render PhlexKit::RadioButton.new(id: "fld-plan-#{value}", name: "fld-plan", value: value, checked: checked)
                  render PhlexKit::FieldLabel.new(for: "fld-plan-#{value}", style: "font-weight: 400") { text }
                end
              end
            end
          end
        end
      end
    end
  end
end
