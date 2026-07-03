# frozen_string_literal: true

module Docs
  module Examples
    module AlertDialog
      class Destructive < Phlex::HTML
        def view_template
          render PhlexKit::AlertDialog.new do
            render PhlexKit::AlertDialogTrigger.new do
              render PhlexKit::Button.new(variant: :destructive) { "Delete Chat" }
            end
            render PhlexKit::AlertDialogContent.new(size: :sm) do
              render PhlexKit::AlertDialogHeader.new do
                render PhlexKit::AlertDialogMedia.new(style: "background: color-mix(in oklab, var(--pk-red) 12%, transparent); color: var(--pk-red)") { "🗑" }
                render PhlexKit::AlertDialogTitle.new { "Delete this chat?" }
                render PhlexKit::AlertDialogDescription.new { "This will permanently delete the conversation and remove it from your history." }
              end
              render PhlexKit::AlertDialogFooter.new do
                render PhlexKit::AlertDialogCancel.new(size: :sm) { "Cancel" }
                render PhlexKit::AlertDialogAction.new(variant: :destructive, size: :sm) { "Delete" }
              end
            end
          end
        end
      end
    end
  end
end
