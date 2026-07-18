module PhlexKit
  # Previous-month button, pinned to the header's left edge. See calendar.rb.
  class CalendarPrev < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      base = {
        type: :button,
        name: "previous-month",
        class: "pk-calendar-prev",
        data: {
          action: "click->phlex-kit--calendar#prevMonth",
          # target so the controller can disable it at the min-date/from-year bound
          phlex_kit__calendar_target: "prevButton"
        }
      }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:aria] = { label: "Go to previous month" } unless aria_labelled?
      button(**mix(base, @attrs)) do
        icon
      end
    end

    private

    def icon
      render Icon.new(:chevron_left, size: 15)
    end
  end
end
