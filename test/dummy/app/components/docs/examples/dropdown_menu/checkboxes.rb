# frozen_string_literal: true

module Docs
  module Examples
    module DropdownMenu
      class Checkboxes < Phlex::HTML
        # Real checkboxes — toggling doesn't close the menu, and the state
        # submits with a form when you pass name:.
        def view_template
          render PhlexKit::DropdownMenu.new do
            render PhlexKit::DropdownMenuTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open" }
            end
            render PhlexKit::DropdownMenuContent.new do
              render PhlexKit::DropdownMenuLabel.new { "Appearance" }
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuCheckboxItem.new(checked: true, name: "status_bar") { "Status Bar" }
              render PhlexKit::DropdownMenuCheckboxItem.new(name: "activity_bar", disabled: true) { "Activity Bar" }
              render PhlexKit::DropdownMenuCheckboxItem.new(name: "panel") { "Panel" }
            end
          end
        end
      end
    end
  end
end
