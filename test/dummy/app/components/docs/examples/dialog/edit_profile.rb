# frozen_string_literal: true

module Docs
  module Examples
    module Dialog
      class EditProfile < Phlex::HTML
        def view_template
          render PhlexKit::Dialog.new do
            render PhlexKit::DialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Edit profile" }
            end
            render PhlexKit::DialogContent.new do
              render PhlexKit::DialogHeader.new do
                render PhlexKit::DialogTitle.new { "Edit profile" }
                render PhlexKit::DialogDescription.new { "Make changes to your profile here. Click save when you're done." }
              end
              render PhlexKit::DialogMiddle.new do
                div(class: "stack") do
                  render PhlexKit::FormField.new do
                    render PhlexKit::FormFieldLabel.new(for: "dlg-name") { "Name" }
                    render PhlexKit::Input.new(id: "dlg-name", value: "Pedro Duarte")
                  end
                  render PhlexKit::FormField.new do
                    render PhlexKit::FormFieldLabel.new(for: "dlg-username") { "Username" }
                    render PhlexKit::Input.new(id: "dlg-username", value: "@peduarte")
                  end
                end
              end
              render PhlexKit::DialogFooter.new do
                render PhlexKit::Button.new(variant: :outline, data: { action: "click->phlex-kit--dialog#dismiss" }) { "Cancel" }
                render PhlexKit::Button.new(data: { action: "click->phlex-kit--dialog#dismiss" }) { "Save changes" }
              end
            end
          end
        end
      end
    end
  end
end
