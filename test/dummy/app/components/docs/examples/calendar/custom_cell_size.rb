# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class CustomCellSize < Phlex::HTML
        def view_template
          # Every cell rides --pk-cell-size — override it to resize the grid.
          render PhlexKit::Card.new(style: "width: fit-content; padding: 0;") do
            render PhlexKit::Calendar.new(selected_date: "2026-06-12", style: "--pk-cell-size: 2.75rem")
          end
        end
      end
    end
  end
end
