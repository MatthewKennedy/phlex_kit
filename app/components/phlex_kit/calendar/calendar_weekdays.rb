module PhlexKit
  # <template> for the weekday header row, cloned into the CalendarBody on every
  # render. See calendar.rb.
  class CalendarWeekdays < BaseComponent
    DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

    def initialize(week_numbers: false, **attrs)
      @week_numbers = week_numbers
      @attrs = attrs
    end

    def view_template
      template(data: { phlex_kit__calendar_target: "weekdaysTemplate" }) do
        thead(**@attrs) do
          tr(class: "pk-calendar-weekdays-row") do
            th(scope: "col", class: "pk-calendar-weekday pk-calendar-weeknumber-head", aria: { label: "Week number" }) { "#" } if @week_numbers
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
