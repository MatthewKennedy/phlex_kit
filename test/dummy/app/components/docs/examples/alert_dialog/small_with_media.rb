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
                render PhlexKit::AlertDialogTitle.new { "Allow accessory to connect?" }
                render PhlexKit::AlertDialogDescription.new { "Do you want to allow the USB accessory to connect to this device?" }
              end
              render PhlexKit::AlertDialogFooter.new do
                render PhlexKit::AlertDialogCancel.new { "Don't allow" }
                render PhlexKit::AlertDialogAction.new { "Allow" }
              end
            end
          end
        end
      end
    end
  end
end
