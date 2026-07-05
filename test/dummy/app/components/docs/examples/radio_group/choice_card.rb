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
          # A bordered label makes the whole card the click target.
          render PhlexKit::RadioGroup.new(class: "w-sm", style: "gap: .75rem") do
            PLANS.each do |value, title, description, checked|
              label(style: "display: flex; gap: .75rem; align-items: flex-start; border: 1px solid var(--pk-border); border-radius: var(--pk-radius); padding: .75rem; cursor: pointer;") do
                render PhlexKit::RadioButton.new(name: "rg-billing", value: value, checked: checked, style: "margin-top: .125rem")
                div do
                  div(style: "font-size: .875rem; font-weight: 500;") { title }
                  p(style: "margin: .25rem 0 0; font-size: .875rem; color: var(--pk-muted);") { description }
                end
              end
            end
          end
        end
      end
    end
  end
end
