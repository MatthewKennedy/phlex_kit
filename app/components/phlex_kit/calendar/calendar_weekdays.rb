module PhlexKit
  # <template> for the weekday header row, cloned into the CalendarBody on every
  # render. See calendar.rb.
  class CalendarWeekdays < BaseComponent
    DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      template(data: { phlex_kit__calendar_target: "weekdaysTemplate" }) do
        thead(**@attrs) do
          tr(class: "pk-calendar-weekdays-row") do
            DAYS.each { |day| render_day(day) }
          end
        end
      end
    end

    private

    def render_day(day)
      th(scope: "col", class: "pk-calendar-weekday", aria: { label: day }) { day[0..1] }
    end
  end
end
