# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class BookedDates < Phlex::HTML
        BOOKED = (12..26).map { |d| Kernel.format("2026-02-%02d", d) }.freeze

        def view_template
          # disabled_dates are unpickable and struck through.
          render PhlexKit::Card.new(style: "width: fit-content; padding: 0;") do
            render PhlexKit::Calendar.new(selected_date: "2026-02-03", disabled_dates: BOOKED)
          end
        end
      end
    end
  end
end
