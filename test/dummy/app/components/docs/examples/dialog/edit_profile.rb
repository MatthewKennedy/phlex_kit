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
                render PhlexKit::FieldGroup.new(style: "gap: 1rem") do
                  render PhlexKit::Field.new do
                    render PhlexKit::FieldLabel.new(for: "dlg-name") { "Name" }
                    render PhlexKit::Input.new(id: "dlg-name", value: "Pedro Duarte")
                  end
                  render PhlexKit::Field.new do
                    render PhlexKit::FieldLabel.new(for: "dlg-username") { "Username" }
                    render PhlexKit::Input.new(id: "dlg-username", value: "@peduarte")
                  end
                end
              end
              render PhlexKit::DialogFooter.new do
                render PhlexKit::DialogClose.new do
                  render PhlexKit::Button.new(variant: :outline) { "Cancel" }
                end
                render PhlexKit::Button.new { "Save changes" }
              end
            end
          end
        end
      end
    end
  end
end
