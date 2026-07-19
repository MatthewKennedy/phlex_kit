# frozen_string_literal: true

module Docs
  module Examples
    module AlertDialog
      # Escape-layering fixture (audit round 9, phase 2): a popover=manual
      # DropdownMenu opened from inside an AlertDialog's panel. One Escape must
      # close only the menu (the menu's own document-level Escape handler owns
      # it); a second Escape then dismisses the alert dialog underneath, rather
      # than the first Escape closing both at once.
      class WithNestedMenu < Phlex::HTML
        def view_template
          render PhlexKit::AlertDialog.new do
            render PhlexKit::AlertDialogTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Show dialog" }
            end
            render PhlexKit::AlertDialogContent.new do
              render PhlexKit::AlertDialogHeader.new do
                render PhlexKit::AlertDialogTitle.new { "Pick an option" }
                render PhlexKit::AlertDialogDescription.new { "A menu lives inside this dialog." }
              end
              render PhlexKit::DropdownMenu.new do
                render PhlexKit::DropdownMenuTrigger.new do
                  render PhlexKit::Button.new(variant: :outline) { "Open menu" }
                end
                render PhlexKit::DropdownMenuContent.new do
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "One" }
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Two" }
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
