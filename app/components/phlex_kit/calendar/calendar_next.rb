module PhlexKit
  # Next-month button, pinned to the header's right edge. See calendar.rb.
  class CalendarNext < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      base = {
        type: :button,
        name: "next-month",
        class: "pk-calendar-next",
        data: {
          action: "click->phlex-kit--calendar#nextMonth",
          # target so the controller can disable it at the max-date/to-year bound
          phlex_kit__calendar_target: "nextButton"
        }
      }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:aria] = { label: "Go to next month" } unless aria_labelled?
      button(**mix(base, @attrs)) do
        icon
      end
    end

    private

    def icon
      render Icon.new(:chevron_right, size: 15)
    end
  end
end
