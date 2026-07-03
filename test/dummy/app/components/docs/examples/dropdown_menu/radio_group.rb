# frozen_string_literal: true

module Docs
  module Examples
    module DropdownMenu
      class RadioGroup < Phlex::HTML
        def view_template
          render PhlexKit::DropdownMenu.new do
            render PhlexKit::DropdownMenuTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open" }
            end
            render PhlexKit::DropdownMenuContent.new do
              render PhlexKit::DropdownMenuLabel.new { "Panel Position" }
              render PhlexKit::DropdownMenuSeparator.new
              render PhlexKit::DropdownMenuRadioGroup.new do
                render PhlexKit::DropdownMenuRadioItem.new(name: "panel_position", value: "top") { "Top" }
                render PhlexKit::DropdownMenuRadioItem.new(name: "panel_position", value: "bottom", checked: true) { "Bottom" }
                render PhlexKit::DropdownMenuRadioItem.new(name: "panel_position", value: "right") { "Right" }
              end
            end
          end
        end
      end
    end
  end
end
