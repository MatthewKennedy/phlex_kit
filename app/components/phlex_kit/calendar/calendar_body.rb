module PhlexKit
  # The <table> the controller renders the weekday header + day grid into.
  # See calendar.rb.
  class CalendarBody < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      table(**mix({
        class: "pk-calendar-body",
        data: {
          phlex_kit__calendar_target: "calendar",
          # Delegated arrow-key/Home/End navigation for the day grid (the
          # buttons are re-rendered wholesale, so the action lives here).
          action: "keydown->phlex-kit--calendar#onKeydown"
        }
      }, @attrs))
    end
  end
end
