module PhlexKit
  # Next-month button, pinned to the header's right edge. See calendar.rb.
  class CalendarNext < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      button(**mix({
        type: :button,
        name: "next-month",
        class: "pk-calendar-next",
        aria: { label: "Go to next month" },
        data: { action: "click->phlex-kit--calendar#nextMonth" }
      }, @attrs)) do
        icon
      end
    end

    private

    def icon
      render Icon.new(:chevron_right, size: 15)
    end
  end
end
