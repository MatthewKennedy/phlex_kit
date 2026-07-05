# frozen_string_literal: true

module Docs
  module Examples
    module Sheet
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Sheet.new do
            render PhlexKit::SheetTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open" }
            end
            render PhlexKit::SheetContent.new do
              render PhlexKit::SheetHeader.new do
                render PhlexKit::SheetTitle.new { "Edit profile" }
                render PhlexKit::SheetDescription.new { "Make changes to your profile here. Click save when you're done." }
              end
              render PhlexKit::SheetMiddle.new do
                div(class: "stack", style: "gap: 1.5rem") do
                  div(class: "stack", style: "gap: .75rem") do
                    render PhlexKit::Label.new(for: "sheet-demo-name") { "Name" }
                    render PhlexKit::Input.new(id: "sheet-demo-name", value: "Pedro Duarte")
                  end
                  div(class: "stack", style: "gap: .75rem") do
                    render PhlexKit::Label.new(for: "sheet-demo-username") { "Username" }
                    render PhlexKit::Input.new(id: "sheet-demo-username", value: "@peduarte")
                  end
                end
              end
              render PhlexKit::SheetFooter.new do
                render PhlexKit::Button.new { "Save changes" }
                render PhlexKit::SheetClose.new do
                  render PhlexKit::Button.new(variant: :outline) { "Close" }
                end
              end
            end
          end
        end
      end
    end
  end
end
