# frozen_string_literal: true

module Docs
  module Examples
    module InputGroup
      class WithDropdown < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::InputGroup.new do
              render PhlexKit::Input.new(placeholder: "Enter file name")
              render PhlexKit::InputGroupAddon.new(align: :end) do
                render PhlexKit::DropdownMenu.new do
                  render PhlexKit::DropdownMenuTrigger.new do
                    render PhlexKit::InputGroupButton.new(icon: true, aria: { label: "File options" }) do
                      render PhlexKit::Icon.new(:ellipsis, size: nil)
                    end
                  end
                  render PhlexKit::DropdownMenuContent.new do
                    render PhlexKit::DropdownMenuItem.new(href: "#") { "Rename" }
                    render PhlexKit::DropdownMenuItem.new(href: "#") { "Duplicate" }
                    render PhlexKit::DropdownMenuSeparator.new
                    render PhlexKit::DropdownMenuItem.new(href: "#", variant: :destructive) { "Delete" }
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
