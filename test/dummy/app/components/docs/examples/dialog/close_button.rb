# frozen_string_literal: true

module Docs
  module Examples
    module Dialog
      class CloseButton < Phlex::HTML
        def view_template
          render PhlexKit::Dialog.new do
            render PhlexKit::DialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Share" }
            end
            render PhlexKit::DialogContent.new(size: :sm) do
              render PhlexKit::DialogHeader.new do
                render PhlexKit::DialogTitle.new { "Share link" }
                render PhlexKit::DialogDescription.new { "Anyone who has this link will be able to view this." }
              end
              render PhlexKit::DialogMiddle.new do
                render PhlexKit::Input.new(id: "dlg-share-link", value: "https://ui.shadcn.com/docs/installation", readonly: true, aria: { label: "Link" })
              end
              render PhlexKit::DialogFooter.new(style: "justify-content: flex-start") do
                render PhlexKit::DialogClose.new do
                  render PhlexKit::Button.new { "Close" }
                end
              end
            end
          end
        end
      end
    end
  end
end
