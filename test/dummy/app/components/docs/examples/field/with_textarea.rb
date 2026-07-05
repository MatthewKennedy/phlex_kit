# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class WithTextarea < Phlex::HTML
        def view_template
          render PhlexKit::FieldSet.new(class: "w-sm") do
            render PhlexKit::FieldGroup.new do
              render PhlexKit::Field.new do
                render PhlexKit::FieldLabel.new(for: "fld-feedback") { "Feedback" }
                render PhlexKit::Textarea.new(id: "fld-feedback", placeholder: "Your feedback helps us improve...", rows: 4)
                render PhlexKit::FieldDescription.new { "Share your thoughts about our service." }
              end
            end
          end
        end
      end
    end
  end
end
