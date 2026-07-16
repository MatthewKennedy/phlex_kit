# frozen_string_literal: true

module Docs
  module Examples
    module AlertDialog
      # Escape-layering fixture (audit round 7, final review): a native
      # Dialog triggered from inside an AlertDialogContent panel. Dialog's
      # Escape/cancel keydown bubbles all the way to the alert dialog's
      # document-level keydown listener (dialog is a DOM descendant) — one
      # Escape must close only the dialog, not the alert dialog underneath.
      class WithNestedDialog < Phlex::HTML
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
              render PhlexKit::Dialog.new do
                render PhlexKit::DialogTrigger.new do
                  render PhlexKit::Button.new(variant: :outline) { "Open nested dialog" }
                end
                render PhlexKit::DialogContent.new do
                  render PhlexKit::DialogHeader.new do
                    render PhlexKit::DialogTitle.new { "Nested dialog" }
                    render PhlexKit::DialogDescription.new { "Stacked on top of the alert dialog." }
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
