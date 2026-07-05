# frozen_string_literal: true

module Docs
  module Examples
    module ContextMenu
      class Destructive < Phlex::HTML
        def view_template
          render PhlexKit::ContextMenu.new do
            render PhlexKit::ContextMenuTrigger.new { trigger_box }
            render PhlexKit::ContextMenuContent.new do
              render PhlexKit::ContextMenuItem.new { "Edit" }
              render PhlexKit::ContextMenuItem.new { "Duplicate" }
              render PhlexKit::ContextMenuSeparator.new
              render PhlexKit::ContextMenuItem.new(variant: :destructive) do
                render PhlexKit::Icon.new(:trash, size: nil)
                plain "Delete"
              end
            end
          end
        end

        private

        def trigger_box
          div(style: "display:flex;aspect-ratio:16/9;width:100%;max-width:20rem;align-items:center;justify-content:center;border:1px dashed var(--pk-border);border-radius:.75rem;font-size:.875rem") do
            "Right click here"
          end
        end
      end
    end
  end
end
