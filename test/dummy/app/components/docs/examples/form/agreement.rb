# frozen_string_literal: true

module Docs
  module Examples
    module Form
      # Two required checkboxes sharing ONE FormField/FormFieldError: exercises
      # the controller's multi-input-target aggregation (task-10) — submitting
      # empty shows the first control's message, and ticking the second control
      # must NOT clear it while the first is still invalid.
      class Agreement < Phlex::HTML
        def view_template
          render PhlexKit::Form.new(action: "#", method: "get", class: "w-md") do
            render PhlexKit::FormField.new do
              render PhlexKit::FormFieldLabel.new { "Agreements" }
              div(class: "flex items-center gap-2") do
                render PhlexKit::Checkbox.new(
                  id: "form-agree-terms", name: "agree_terms", required: true,
                  data: { value_missing: "You must agree to the terms." }
                )
                label(for: "form-agree-terms") { "I agree to the terms of service" }
              end
              div(class: "flex items-center gap-2") do
                render PhlexKit::Checkbox.new(
                  id: "form-agree-privacy", name: "agree_privacy", required: true,
                  data: { value_missing: "You must agree to the privacy policy." }
                )
                label(for: "form-agree-privacy") { "I agree to the privacy policy" }
              end
              render PhlexKit::FormFieldError.new
            end
            div(class: "pk-form-actions") do
              render PhlexKit::Button.new(type: :submit) { "Agree" }
            end
          end
        end
      end
    end
  end
end
