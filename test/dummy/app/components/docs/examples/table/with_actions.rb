# frozen_string_literal: true

module Docs
  module Examples
    module Table
      class WithActions < Phlex::HTML
        ROWS = [
          [ "Sarah Chen", "sarah.chen@example.com", "Admin" ],
          [ "Marcus Rodriguez", "marcus.rodriguez@example.com", "User" ],
          [ "Priya Patel", "priya.patel@example.com", "Editor" ]
        ].freeze

        def view_template
          div(class: "w-lg") do
            render PhlexKit::Table.new do
              render PhlexKit::TableHeader.new do
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableHead.new { "Name" }
                  render PhlexKit::TableHead.new { "Email" }
                  render PhlexKit::TableHead.new { "Role" }
                  render PhlexKit::TableHead.new(style: "width: 2rem") { span(class: "pk-sr-only") { "Actions" } }
                end
              end
              render PhlexKit::TableBody.new do
                ROWS.each do |name, email, role|
                  render PhlexKit::TableRow.new do
                    render PhlexKit::TableCell.new(style: "font-weight: 500") { name }
                    render PhlexKit::TableCell.new { email }
                    render PhlexKit::TableCell.new { role }
                    render PhlexKit::TableCell.new do
                      render PhlexKit::DropdownMenu.new do
                        render PhlexKit::DropdownMenuTrigger.new do
                          render PhlexKit::Button.new(variant: :ghost, icon: true, aria: { label: "Open menu for #{name}" }) do
                            render PhlexKit::Icon.new(:ellipsis, size: nil)
                          end
                        end
                        render PhlexKit::DropdownMenuContent.new(style: "left: auto; right: 0") do
                          render PhlexKit::DropdownMenuItem.new(href: "#") { "Edit" }
                          render PhlexKit::DropdownMenuItem.new(href: "#") { "Copy email" }
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
    end
  end
end
