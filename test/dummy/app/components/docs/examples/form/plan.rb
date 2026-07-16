# frozen_string_literal: true

module Docs
  module Examples
    module Form
      # A RadioGroup sharing one FormField/FormFieldError: exercises native
      # radio-group validity (the browser reports the WHOLE named group valid
      # once any one radio is checked, even the ones still unchecked) against
      # the controller's multi-input-target aggregation (task-10) — the shared
      # error must clear for every radio in the group, not just the one that
      # received the click.
      class Plan < Phlex::HTML
        PLANS = [ "monthly", "yearly", "lifetime" ].freeze

        def view_template
          render PhlexKit::Form.new(action: "#", method: "get", class: "w-md") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new { "Subscription plan" }
              render PhlexKit::RadioGroup.new do
                PLANS.each do |plan|
                  div(class: "flex items-center gap-2") do
                    render PhlexKit::RadioButton.new(
                      id: "form-plan-#{plan}", name: "form_plan", value: plan, required: true,
                      data: { value_missing: "Pick a subscription plan." }
                    )
                    label(for: "form-plan-#{plan}") { plan.capitalize }
                  end
                end
              end
              render PhlexKit::FormFieldError.new
            end
            div(class: "pk-form-actions") do
              render PhlexKit::Button.new(type: :submit) { "Subscribe" }
            end
          end
        end
      end
    end
  end
end
