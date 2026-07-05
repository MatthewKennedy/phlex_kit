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
                render PhlexKit::MenubarItem.new(data: { disabled: "true" }) { "New Incognito Window" }
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarSub.new do
                  render PhlexKit::MenubarSubTrigger.new { "Share" }
                  render PhlexKit::MenubarSubContent.new do
                    render PhlexKit::MenubarItem.new { "Email link" }
                    render PhlexKit::MenubarItem.new { "Messages" }
                    render PhlexKit::MenubarItem.new { "Notes" }
                  end
                end
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarItem.new(shortcut: "⌘P") { "Print…" }
              end
            end
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "Edit" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarItem.new(shortcut: "⌘Z") { "Undo" }
                render PhlexKit::MenubarItem.new(shortcut: "⇧⌘Z") { "Redo" }
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarSub.new do
                  render PhlexKit::MenubarSubTrigger.new { "Find" }
                  render PhlexKit::MenubarSubContent.new do
                    render PhlexKit::MenubarItem.new { "Search the web" }
                    render PhlexKit::MenubarSeparator.new
                    render PhlexKit::MenubarItem.new { "Find…" }
                    render PhlexKit::MenubarItem.new { "Find Next" }
                    render PhlexKit::MenubarItem.new { "Find Previous" }
                  end
                end
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarItem.new { "Cut" }
                render PhlexKit::MenubarItem.new { "Copy" }
                render PhlexKit::MenubarItem.new { "Paste" }
              end
            end
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "View" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarCheckboxItem.new { "Always Show Bookmarks Bar" }
                render PhlexKit::MenubarCheckboxItem.new(checked: true) { "Always Show Full URLs" }
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarItem.new(inset: true, shortcut: "⌘R") { "Reload" }
                render PhlexKit::MenubarItem.new(inset: true, shortcut: "⇧⌘R", data: { disabled: "true" }) { "Force Reload" }
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarItem.new(inset: true) { "Toggle Fullscreen" }
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarItem.new(inset: true) { "Hide Sidebar" }
              end
            end
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "Profiles" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarRadioGroup.new do
                  render PhlexKit::MenubarRadioItem.new(name: "mb-profile", value: "andy") { "Andy" }
                  render PhlexKit::MenubarRadioItem.new(name: "mb-profile", value: "benoit", checked: true) { "Benoit" }
                  render PhlexKit::MenubarRadioItem.new(name: "mb-profile", value: "luis") { "Luis" }
                end
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarItem.new(inset: true) { "Edit…" }
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarItem.new(inset: true) { "Add Profile…" }
              end
            end
          end
        end
      end
    end
  end
end
