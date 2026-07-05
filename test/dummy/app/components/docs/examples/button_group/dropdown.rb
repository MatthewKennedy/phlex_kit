# frozen_string_literal: true

module Docs
  module Examples
    module ButtonGroup
      class Dropdown < Phlex::HTML
        def view_template
          render PhlexKit::ButtonGroup.new do
            render PhlexKit::Button.new(variant: :outline) { "Follow" }
            render PhlexKit::DropdownMenu.new do
              render PhlexKit::DropdownMenuTrigger.new do
                render PhlexKit::Button.new(variant: :outline, icon: true) do
                  render PhlexKit::Icon.new(:chevron_down, size: nil)
                end
              end
              render PhlexKit::DropdownMenuContent.new(style: "min-width: 11rem") do
                render PhlexKit::DropdownMenuGroup.new do
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Mute Conversation" }
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Mark as Read" }
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Report Conversation" }
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Block User" }
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Share Conversation" }
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Copy Conversation" }
                end
                render PhlexKit::DropdownMenuSeparator.new
                render PhlexKit::DropdownMenuGroup.new do
                  render PhlexKit::DropdownMenuItem.new(href: "#", variant: :destructive) { "Delete Conversation" }
                end
              end
            end
          end
        end
      end
    end
  end
end
