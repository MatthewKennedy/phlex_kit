# frozen_string_literal: true

module Docs
  module Examples
    module AlertDialog
      # Escape-layering fixture (audit round 7, task 12): a Sheet triggered
      # from inside an AlertDialog's panel, so the two clone-based overlays
      # stack (alert dialog opens first, sheet opens on top of it). One
      # Escape must close only the topmost overlay (the sheet); a second
      # Escape then closes the alert dialog underneath.
      class WithNestedSheet < Phlex::HTML
        def view_template
          render PhlexKit::AlertDialog.new do
            render PhlexKit::AlertDialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Show dialog" }
            end
            render PhlexKit::AlertDialogContent.new do
              render PhlexKit::AlertDialogHeader.new do
                render PhlexKit::AlertDialogTitle.new { "Are you absolutely sure?" }
                render PhlexKit::AlertDialogDescription.new { "This action cannot be undone." }
              end
              render PhlexKit::Sheet.new do
                render PhlexKit::SheetTrigger.new do
                  render PhlexKit::Button.new(variant: :outline) { "Open nested sheet" }
                end
                render PhlexKit::SheetContent.new do
                  render PhlexKit::SheetHeader.new do
                    render PhlexKit::SheetTitle.new { "Nested sheet" }
                    render PhlexKit::SheetDescription.new { "Stacked on top of the alert dialog." }
                  end
                end
              end
              render PhlexKit::AlertDialogFooter.new do
                render PhlexKit::AlertDialogCancel.new { "Cancel" }
                render PhlexKit::AlertDialogAction.new { "Continue" }
              end
            end
          end
        end
      end
    end
  end
end
