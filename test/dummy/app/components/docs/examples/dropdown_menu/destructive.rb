# frozen_string_literal: true

module Docs
  module Examples
    module DropdownMenu
      class Destructive < Phlex::HTML
        def view_template
          render PhlexKit::DropdownMenu.new do
            render PhlexKit::DropdownMenuTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Actions" }
            end
            render PhlexKit::DropdownMenuContent.new do
              render PhlexKit::DropdownMenuItem.new(href: "#") { "✏ Edit" }
              render PhlexKit::DropdownMenuItem.new(href: "#") { "↗ Share" }
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuItem.new(href: "#", variant: :destructive) { "🗑 Delete" }
            end
          end
        end
      end
    end
  end
end
