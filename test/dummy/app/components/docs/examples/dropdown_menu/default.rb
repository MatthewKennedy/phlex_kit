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
              render PhlexKit::DropdownMenuLabel.new { "My Account" }
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuItem.new(href: "#") { "Profile" }
              render PhlexKit::DropdownMenuItem.new(href: "#") { "Billing" }
              render PhlexKit::DropdownMenuItem.new(href: "#") { "Team" }
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuItem.new(href: "#") { "Log out" }
            end
          end
        end
      end
    end
  end
end
