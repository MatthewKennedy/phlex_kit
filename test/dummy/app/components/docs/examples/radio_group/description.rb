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
              div(class: "row", style: "align-items: flex-start") do
                render PhlexKit::RadioButton.new(id: "plan-#{value}", name: "rg-plan", value: value, checked: checked, style: "margin-top: .125rem")
                div do
                  render PhlexKit::Label.new(for: "plan-#{value}") { title }
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
