# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class DateAndTime < Phlex::HTML
        def view_template
          render PhlexKit::Card.new(style: "width: fit-content; padding: 0;") do
            render PhlexKit::Calendar.new(selected_date: "2026-06-12")
            div(style: "border-top: 1px solid var(--pk-border); padding: .75rem;") do
              render PhlexKit::Field.new(orientation: :horizontal) do
                render PhlexKit::FieldLabel.new(for: "cal-time") { "Time" }
                render PhlexKit::Input.new(id: "cal-time", type: :time, value: "10:30", style: "width: auto")
              end
            end
          end
        end
      end
    end
  end
end
