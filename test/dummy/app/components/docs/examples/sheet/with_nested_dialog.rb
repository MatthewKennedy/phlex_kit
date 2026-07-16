# frozen_string_literal: true

module Docs
  module Examples
    module Sheet
      # Escape-layering fixture (audit round 7, task 12): a native Dialog
      # triggered from inside a SheetContent panel. Dialog's Escape/cancel
      # keydown bubbles through the sheet clone's element-scoped keydown
      # listener (the dialog is a DOM descendant) — one Escape must close
      # only the dialog, not the sheet underneath.
      class WithNestedDialog < Phlex::HTML
        def view_template
          render PhlexKit::Sheet.new do
            render PhlexKit::SheetTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open" }
            end
            render PhlexKit::SheetContent.new do
              render PhlexKit::SheetHeader.new do
                render PhlexKit::SheetTitle.new { "Sheet with nested dialog" }
                render PhlexKit::SheetDescription.new { "Opens a native dialog on top." }
              end
              render PhlexKit::Dialog.new do
                render PhlexKit::DialogTrigger.new do
                  render PhlexKit::Button.new(variant: :outline) { "Open nested dialog" }
                end
                render PhlexKit::DialogContent.new do
                  render PhlexKit::DialogHeader.new do
                    render PhlexKit::DialogTitle.new { "Nested dialog" }
                    render PhlexKit::DialogDescription.new { "Stacked on top of the sheet." }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
