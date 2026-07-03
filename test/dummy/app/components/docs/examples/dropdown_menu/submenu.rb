# frozen_string_literal: true

module Docs
  module Examples
    module DropdownMenu
      class Submenu < Phlex::HTML
        def view_template
          render PhlexKit::DropdownMenu.new do
            render PhlexKit::DropdownMenuTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open" }
            end
            render PhlexKit::DropdownMenuContent.new do
              render PhlexKit::DropdownMenuItem.new(href: "#") { "New Tab" }
              render PhlexKit::DropdownMenuItem.new(href: "#") { "New Window" }
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuSub.new do
                render PhlexKit::DropdownMenuSubTrigger.new { "More Tools" }
                render PhlexKit::DropdownMenuSubContent.new do
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Save Page As…" }
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Create Shortcut…" }
                  render PhlexKit::DropdownMenuSeparator.new
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Developer Tools" }
                end
              end
            end
          end
        end
      end
    end
  end
end
