# frozen_string_literal: true

module Docs
  module Examples
    module Checkbox
      class InTable < Phlex::HTML
        ROWS = [
          [ "1", "Sarah Chen", "sarah.chen@example.com", "Admin", true ],
          [ "2", "Marcus Rodriguez", "marcus.rodriguez@example.com", "User", false ],
          [ "3", "Priya Patel", "priya.patel@example.com", "User", false ],
          [ "4", "David Kim", "david.kim@example.com", "Editor", false ]
        ].freeze

        def view_template
          div(class: "w-lg") do
            render PhlexKit::Table.new do
              render PhlexKit::TableHeader.new do
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableHead.new(style: "width: 2rem") do
                    render PhlexKit::Checkbox.new(aria: { label: "Select all" })
                  end
                  render PhlexKit::TableHead.new { "Name" }
                  render PhlexKit::TableHead.new { "Email" }
                  render PhlexKit::TableHead.new { "Role" }
                end
              end
              render PhlexKit::TableBody.new do
                ROWS.each do |id, name, email, role, checked|
                  render PhlexKit::TableRow.new do
                    render PhlexKit::TableCell.new do
                      render PhlexKit::Checkbox.new(checked: checked, aria: { label: "Select #{name}" })
                    end
                    render PhlexKit::TableCell.new { name }
                    render PhlexKit::TableCell.new { email }
                    render PhlexKit::TableCell.new { role }
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
