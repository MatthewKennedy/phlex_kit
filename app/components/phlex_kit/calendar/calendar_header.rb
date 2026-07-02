module PhlexKit
  # Header row of a PhlexKit::Calendar — centers the CalendarTitle, with
  # CalendarPrev/CalendarNext pinned to its edges. See calendar.rb.
  class CalendarHeader < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-calendar-header" }, @attrs), &)
    end
  end
end
