# frozen_string_literal: true

module Docs
  module Examples
    module AlertDialog
      # Custom-role fixture (audit round 9, phase 2): AlertDialogContent lets
      # the caller override role:, so the controller must locate its panel
      # structurally (.pk-alert-dialog-panel), not by [role="alertdialog"].
      # With role: "dialog" the full modal contract — focus trap, aria wiring,
      # Escape-to-dismiss — must still work.
      class CustomRole < Phlex::HTML
        def view_template
          render PhlexKit::AlertDialog.new do
            render PhlexKit::AlertDialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Show dialog" }
            end
            render PhlexKit::AlertDialogContent.new(role: "dialog") do
              render PhlexKit::AlertDialogHeader.new do
                render PhlexKit::AlertDialogTitle.new { "Custom role" }
                render PhlexKit::AlertDialogDescription.new { "This panel uses role=dialog." }
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
