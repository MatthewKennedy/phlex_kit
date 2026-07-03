# frozen_string_literal: true

module Docs
  module Examples
    module DropdownMenu
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::DropdownMenu.new do
            render PhlexKit::DropdownMenuTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open" }
            end
            render PhlexKit::DropdownMenuContent.new do
              render PhlexKit::DropdownMenuGroup.new do
                render PhlexKit::DropdownMenuLabel.new { "My Account" }
                render PhlexKit::DropdownMenuItem.new(href: "#") { "Profile" }
                render PhlexKit::DropdownMenuItem.new(href: "#") { "Billing" }
              end
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuGroup.new do
                render PhlexKit::DropdownMenuItem.new(href: "#") { "Team" }
                render PhlexKit::DropdownMenuItem.new(href: "#") { "Subscription" }
              end
            end
          end
        end
      end
    end
  end
end
