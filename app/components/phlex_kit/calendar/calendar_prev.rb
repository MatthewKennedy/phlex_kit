module PhlexKit
  # Previous-month button, pinned to the header's left edge. See calendar.rb.
  class CalendarPrev < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      button(**mix({
        type: :button,
        name: "previous-month",
        class: "pk-calendar-prev",
        aria: { label: "Go to previous month" },
        data: { action: "click->phlex-kit--calendar#prevMonth" }
      }, @attrs)) do
        icon
      end
    end

    private

    def icon
      render Icon.new(:chevron_left, size: 15)
    end
  end
end
