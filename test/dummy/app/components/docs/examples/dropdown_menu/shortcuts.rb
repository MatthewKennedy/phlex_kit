# frozen_string_literal: true

module Docs
  module Examples
    module DropdownMenu
      class Shortcuts < Phlex::HTML
        def view_template
          render PhlexKit::DropdownMenu.new do
            render PhlexKit::DropdownMenuTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open" }
            end
            render PhlexKit::DropdownMenuContent.new do
              render PhlexKit::DropdownMenuItem.new(href: "#") do
                plain "Back"
                render PhlexKit::DropdownMenuShortcut.new { "⌘[" }
              end
              render PhlexKit::DropdownMenuItem.new(href: "#") do
                plain "Forward"
                render PhlexKit::DropdownMenuShortcut.new { "⌘]" }
              end
              render PhlexKit::DropdownMenuItem.new(href: "#") do
                plain "Reload"
                render PhlexKit::DropdownMenuShortcut.new { "⌘R" }
              end
            end
          end
        end
      end
    end
  end
end
