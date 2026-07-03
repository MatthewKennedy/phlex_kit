# frozen_string_literal: true

module Docs
  module Examples
    module AlertDialog
      class Media < Phlex::HTML
        def view_template
          render PhlexKit::AlertDialog.new do
            render PhlexKit::AlertDialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Share Project" }
            end
            render PhlexKit::AlertDialogContent.new do
              render PhlexKit::AlertDialogHeader.new do
                render PhlexKit::AlertDialogMedia.new { "⊕" }
                render PhlexKit::AlertDialogTitle.new { "Share this project?" }
                render PhlexKit::AlertDialogDescription.new { "Everyone with the link can view and comment. You can change this anytime in project settings." }
              end
              render PhlexKit::AlertDialogFooter.new do
                render PhlexKit::AlertDialogCancel.new { "Cancel" }
                render PhlexKit::AlertDialogAction.new { "Share" }
              end
            end
          end
        end
      end
    end
  end
end
