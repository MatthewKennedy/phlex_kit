# frozen_string_literal: true

module Docs
  module Examples
    module Menubar
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Menubar.new do
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "File" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarItem.new(shortcut: "⌘T") { "New Tab" }
                render PhlexKit::MenubarItem.new(shortcut: "⌘N") { "New Window" }
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarItem.new(shortcut: "⌘P") { "Print…" }
              end
            end
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "Edit" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarItem.new(shortcut: "⌘Z") { "Undo" }
                render PhlexKit::MenubarItem.new(shortcut: "⇧⌘Z") { "Redo" }
              end
            end
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "View" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarItem.new { "Reload" }
                render PhlexKit::MenubarItem.new { "Toggle Fullscreen" }
              end
            end
          end
        end
      end
    end
  end
end
