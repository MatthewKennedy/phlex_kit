# frozen_string_literal: true

module Docs
  module Examples
    module Avatar
      class Dropdown < Phlex::HTML
        def view_template
          render PhlexKit::DropdownMenu.new do
            render PhlexKit::DropdownMenuTrigger.new do
              render PhlexKit::Avatar.new do
                render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "shadcn")
                render PhlexKit::AvatarFallback.new { "CN" }
              end
            end
            render PhlexKit::DropdownMenuContent.new(style: "min-width: 8rem") do
              render PhlexKit::DropdownMenuGroup.new do
                render PhlexKit::DropdownMenuItem.new(href: "#") { "Profile" }
                render PhlexKit::DropdownMenuItem.new(href: "#") { "Billing" }
                render PhlexKit::DropdownMenuItem.new(href: "#") { "Settings" }
              end
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuGroup.new do
                render PhlexKit::DropdownMenuItem.new(href: "#", variant: :destructive) { "Log out" }
              end
            end
          end
        end
      end
    end
  end
end
