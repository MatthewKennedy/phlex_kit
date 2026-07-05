# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class Range < Phlex::HTML
        def view_template
          # Pick a start, then an end — the band paints between the caps.
          render PhlexKit::Card.new(style: "width: fit-content; padding: 0;") do
            render PhlexKit::Calendar.new(mode: :range, range_start: "2026-01-12", range_end: "2026-02-11", min_date: "1900-01-01")
          end
        end
      end
    end
  end
end
