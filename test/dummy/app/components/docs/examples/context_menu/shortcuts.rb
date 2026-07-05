# frozen_string_literal: true

module Docs
  module Examples
    module ContextMenu
      class Shortcuts < Phlex::HTML
        def view_template
          render PhlexKit::ContextMenu.new do
            render PhlexKit::ContextMenuTrigger.new { trigger_box }
            render PhlexKit::ContextMenuContent.new do
              render PhlexKit::ContextMenuItem.new(shortcut: "⌘[") { "Back" }
              render PhlexKit::ContextMenuItem.new(shortcut: "⌘]", disabled: true) { "Forward" }
              render PhlexKit::ContextMenuItem.new(shortcut: "⌘R") { "Reload" }
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
