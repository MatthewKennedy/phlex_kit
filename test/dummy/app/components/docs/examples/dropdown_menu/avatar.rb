# frozen_string_literal: true

module Docs
  module Examples
    module DropdownMenu
      class Avatar < Phlex::HTML
        # An account switcher triggered by an avatar.
        def view_template
          render PhlexKit::DropdownMenu.new do
            render PhlexKit::DropdownMenuTrigger.new do
              render PhlexKit::Avatar.new do
                render PhlexKit::AvatarFallback.new { "CN" }
              end
            end
            render PhlexKit::DropdownMenuContent.new do
              render PhlexKit::DropdownMenuLabel.new { "shadcn — m@example.com" }
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuItem.new(href: "#") do
                plain "✓ Account"
                render PhlexKit::DropdownMenuShortcut.new { "⇧⌘P" }
              end
              render PhlexKit::DropdownMenuItem.new(href: "#") { "💳 Billing" }
              render PhlexKit::DropdownMenuItem.new(href: "#") { "🔔 Notifications" }
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuItem.new(href: "#") { "Log out" }
            end
          end
        end
      end
    end
  end
end
