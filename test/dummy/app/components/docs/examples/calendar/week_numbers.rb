# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class WeekNumbers < Phlex::HTML
        def view_template
          render PhlexKit::Card.new(style: "width: fit-content; padding: 0;") do
            render PhlexKit::Calendar.new(selected_date: "2026-02-03", week_numbers: true)
          end
        end
      end
    end
  end
end
