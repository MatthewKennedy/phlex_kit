# frozen_string_literal: true

module Docs
  module Examples
    module Sheet
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Sheet.new do
            render PhlexKit::SheetTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open sheet" }
            end
            render PhlexKit::SheetContent.new(side: :right) do
              render PhlexKit::SheetHeader.new do
                render PhlexKit::SheetTitle.new { "Edit profile" }
                render PhlexKit::SheetDescription.new { "Make changes to your profile here." }
              end
              render PhlexKit::SheetMiddle.new do
                render PhlexKit::FormField.new do
                  render PhlexKit::FormFieldLabel.new(for: "sheet-name") { "Name" }
                  render PhlexKit::Input.new(id: "sheet-name", value: "Pedro Duarte")
                end
              end
              render PhlexKit::SheetFooter.new do
                render PhlexKit::Button.new(data: { action: "click->phlex-kit--sheet-content#close" }) { "Save changes" }
              end
            end
          end
        end
      end
    end
  end
end
