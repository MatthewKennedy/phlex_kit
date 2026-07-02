# frozen_string_literal: true

module Docs
  module Examples
    module AlertDialog
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::AlertDialog.new do
            render PhlexKit::AlertDialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Show dialog" }
            end
            render PhlexKit::AlertDialogContent.new do
              render PhlexKit::AlertDialogHeader.new do
                render PhlexKit::AlertDialogTitle.new { "Are you absolutely sure?" }
                render PhlexKit::AlertDialogDescription.new do
                  "This action cannot be undone. This will permanently delete your account and remove your data from our servers."
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
