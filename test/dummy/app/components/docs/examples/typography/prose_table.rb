# frozen_string_literal: true

module Docs
  module Examples
    module Typography
      class ProseTable < Phlex::HTML
        TREASURY = [
          [ "King's Treasury", "Empty" ],
          [ "People's happiness", "Overflowing" ]
        ].freeze

        def view_template
          div(class: "w-md") do
            render PhlexKit::Table.new do
              render PhlexKit::TableHeader.new do
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableHead.new { "King's Treasury" }
                  render PhlexKit::TableHead.new { "People's happiness" }
                end
              end
              render PhlexKit::TableBody.new do
                TREASURY.each do |treasury, happiness|
                  render PhlexKit::TableRow.new do
                    render PhlexKit::TableCell.new { treasury }
                    render PhlexKit::TableCell.new { happiness }
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
