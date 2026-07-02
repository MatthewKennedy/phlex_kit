module PhlexKit
  # "Month Year" heading — rewritten by the controller as you navigate.
  # See calendar.rb.
  class CalendarTitle < BaseComponent
    def initialize(default: "Month Year", **attrs)
      @default = default
      @attrs = attrs
    end

    def view_template
      div(**mix({
        class: "pk-calendar-title",
        role: "presentation",
        aria: { live: "polite" },
        data: { phlex_kit__calendar_target: "title" }
      }, @attrs)) { @default }
    end
  end
end
