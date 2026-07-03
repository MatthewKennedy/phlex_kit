# frozen_string_literal: true

module Docs
  module Examples
    module AlertDialog
      class SmallWithMedia < Phlex::HTML
        def view_template
          render PhlexKit::AlertDialog.new do
            render PhlexKit::AlertDialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Show Dialog" }
            end
            render PhlexKit::AlertDialogContent.new(size: :sm) do
              render PhlexKit::AlertDialogHeader.new do
                render PhlexKit::AlertDialogMedia.new { "ᛒ" }
                render PhlexKit::AlertDialogTitle.new { "Allow Bluetooth?" }
                render PhlexKit::AlertDialogDescription.new { "Nearby devices will be able to discover this computer." }
              end
              render PhlexKit::AlertDialogFooter.new do
                render PhlexKit::AlertDialogCancel.new(size: :sm) { "Don't Allow" }
                render PhlexKit::AlertDialogAction.new(size: :sm) { "Allow" }
              end
            end
          end
        end
      end
    end
  end
end
