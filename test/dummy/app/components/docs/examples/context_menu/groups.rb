# frozen_string_literal: true

module Docs
  module Examples
    module ContextMenu
      class Groups < Phlex::HTML
        def view_template
          render PhlexKit::ContextMenu.new do
            render PhlexKit::ContextMenuTrigger.new { trigger_box }
            render PhlexKit::ContextMenuContent.new do
              render PhlexKit::ContextMenuGroup.new do
                render PhlexKit::ContextMenuLabel.new { "File" }
                render PhlexKit::ContextMenuItem.new(shortcut: "⌘N") { "New File" }
                render PhlexKit::ContextMenuItem.new(shortcut: "⌘O") { "Open File" }
                render PhlexKit::ContextMenuItem.new(shortcut: "⌘S") { "Save" }
              end
              render PhlexKit::ContextMenuSeparator.new
              render PhlexKit::ContextMenuGroup.new do
                render PhlexKit::ContextMenuLabel.new { "Edit" }
                render PhlexKit::ContextMenuItem.new(shortcut: "⌘Z") { "Undo" }
                render PhlexKit::ContextMenuItem.new(shortcut: "⇧⌘Z") { "Redo" }
              end
              render PhlexKit::ContextMenuSeparator.new
              render PhlexKit::ContextMenuGroup.new do
                render PhlexKit::ContextMenuItem.new(shortcut: "⌘X") { "Cut" }
                render PhlexKit::ContextMenuItem.new(shortcut: "⌘C") { "Copy" }
                render PhlexKit::ContextMenuItem.new(shortcut: "⌘V") { "Paste" }
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
