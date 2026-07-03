# frozen_string_literal: true

module Docs
  module Examples
    module AlertDialog
      class Small < Phlex::HTML
        def view_template
          render PhlexKit::AlertDialog.new do
            render PhlexKit::AlertDialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Show Dialog" }
            end
            render PhlexKit::AlertDialogContent.new(size: :sm) do
              render PhlexKit::AlertDialogHeader.new do
                render PhlexKit::AlertDialogTitle.new { "Discard draft?" }
                render PhlexKit::AlertDialogDescription.new { "Your unsaved changes will be lost." }
              end
              render PhlexKit::AlertDialogFooter.new do
                render PhlexKit::AlertDialogCancel.new { "Cancel" }
                render PhlexKit::AlertDialogAction.new { "Discard" }
              end
            end
          end
        end
      end
    end
  end
end
