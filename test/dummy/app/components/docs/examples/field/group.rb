# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class Group < Phlex::HTML
        def view_template
          render PhlexKit::FieldGroup.new(class: "w-sm") do
            render PhlexKit::FieldSet.new do
              render PhlexKit::FieldTitle.new { "Responses" }
              render PhlexKit::FieldDescription.new { "Get notified when the assistant responds to requests that take time, like research or image generation." }
              render PhlexKit::FieldGroup.new(style: "gap: .75rem") do
                render PhlexKit::Field.new(orientation: :horizontal, disabled: true) do
                  render PhlexKit::Checkbox.new(id: "fld-push", name: "fld-push", checked: true, disabled: true)
                  render PhlexKit::FieldLabel.new(for: "fld-push", style: "font-weight: 400") { "Push notifications" }
                end
              end
            end
            render PhlexKit::FieldSeparator.new
            render PhlexKit::FieldSet.new do
              render PhlexKit::FieldTitle.new { "Tasks" }
              render PhlexKit::FieldDescription.new do
                plain "Get notified when tasks you've created have updates. "
                a(href: "#") { "Manage tasks" }
              end
              render PhlexKit::FieldGroup.new(style: "gap: .75rem") do
                render PhlexKit::Field.new(orientation: :horizontal) do
                  render PhlexKit::Checkbox.new(id: "fld-push-tasks", name: "fld-push-tasks")
                  render PhlexKit::FieldLabel.new(for: "fld-push-tasks", style: "font-weight: 400") { "Push notifications" }
                end
                render PhlexKit::Field.new(orientation: :horizontal) do
                  render PhlexKit::Checkbox.new(id: "fld-email-tasks", name: "fld-email-tasks")
                  render PhlexKit::FieldLabel.new(for: "fld-email-tasks", style: "font-weight: 400") { "Email notifications" }
                end
              end
            end
          end
        end
      end
    end
  end
end
