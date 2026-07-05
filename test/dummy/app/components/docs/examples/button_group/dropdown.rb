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
              render PhlexKit::DropdownMenuContent.new(style: "min-width: 14rem") do
                render PhlexKit::DropdownMenuGroup.new do
                  render PhlexKit::DropdownMenuItem.new(href: "#") do
                    render PhlexKit::Icon.new(:volume_off, size: nil)
                    plain "Mute Conversation"
                  end
                  render PhlexKit::DropdownMenuItem.new(href: "#") do
                    render PhlexKit::Icon.new(:check, size: nil)
                    plain "Mark as Read"
                  end
                  render PhlexKit::DropdownMenuItem.new(href: "#") do
                    render PhlexKit::Icon.new(:triangle_alert, size: nil)
                    plain "Report Conversation"
                  end
                  render PhlexKit::DropdownMenuItem.new(href: "#") do
                    render PhlexKit::Icon.new(:user_x, size: nil)
                    plain "Block User"
                  end
                  render PhlexKit::DropdownMenuItem.new(href: "#") do
                    render PhlexKit::Icon.new(:share, size: nil)
                    plain "Share Conversation"
                  end
                  render PhlexKit::DropdownMenuItem.new(href: "#") do
                    render PhlexKit::Icon.new(:copy, size: nil)
                    plain "Copy Conversation"
                  end
                end
                render PhlexKit::DropdownMenuSeparator.new
                render PhlexKit::DropdownMenuGroup.new do
                  render PhlexKit::DropdownMenuItem.new(href: "#", variant: :destructive) do
                    render PhlexKit::Icon.new(:trash, size: nil)
                    plain "Delete Conversation"
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
