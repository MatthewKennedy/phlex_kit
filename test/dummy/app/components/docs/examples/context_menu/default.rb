# frozen_string_literal: true

module Docs
  module Examples
    module ContextMenu
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::ContextMenu.new do
            render PhlexKit::ContextMenuTrigger.new do
              div(style: "display:flex;align-items:center;justify-content:center;width:300px;height:150px;border:1px dashed var(--pk-border);border-radius:var(--pk-radius);font-size:.875rem") do
                "Right click here"
              end
            end
            render PhlexKit::ContextMenuContent.new do
              render PhlexKit::ContextMenuItem.new(shortcut: "⌘[") { "Back" }
              render PhlexKit::ContextMenuItem.new(shortcut: "⌘]", disabled: true) { "Forward" }
              render PhlexKit::ContextMenuItem.new(shortcut: "⌘R") { "Reload" }
              render PhlexKit::ContextMenuSeparator.new
              render PhlexKit::ContextMenuItem.new(checked: true) { "Show Bookmarks Bar" }
              render PhlexKit::ContextMenuItem.new { "Show Full URLs" }
            end
          end
        end
      end
    end
  end
end
