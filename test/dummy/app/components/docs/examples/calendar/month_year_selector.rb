# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class MonthYearSelector < Phlex::HTML
        def view_template
          # caption_layout: :dropdown swaps the title for native selects.
          div(style: "border: 1px solid var(--pk-border); border-radius: var(--pk-radius); width: fit-content;") do
            render PhlexKit::Calendar.new(selected_date: "2026-06-12", caption_layout: :dropdown, from_year: 2020, to_year: 2030)
          end
        end
      end
    end
  end
end
