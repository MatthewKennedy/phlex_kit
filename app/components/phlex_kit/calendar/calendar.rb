module PhlexKit
  # Calendar (month grid with day selection), ported from ruby_ui's
  # RubyUI::Calendar. Renders the header (title + prev/next), the <table> the
  # phlex-kit--calendar controller fills, and the <template>s it clones per day
  # state (upstream's Mustache dependency is replaced with a tiny {{key}}
  # interpolator in the controller). Pass `input_id:` a CSS selector (e.g.
  # "#due-date") to push the picked date into a phlex-kit--calendar-input outlet —
  # that's how PhlexKit::DatePicker binds it to an Input. Tailwind → vanilla
  # `.pk-calendar*` (calendar.css).
  class Calendar < BaseComponent
    def initialize(selected_date: nil, min_date: nil, input_id: nil, date_format: "yyyy-MM-dd", **attrs)
      @selected_date = selected_date
      @min_date = min_date
      @input_id = input_id
      @date_format = date_format
      @attrs = attrs
    end

    def view_template
      div(**mix(calendar_attrs, @attrs)) do
        render CalendarHeader.new do
          render CalendarTitle.new
          render CalendarPrev.new
          render CalendarNext.new
        end
        render CalendarBody.new # Where the calendar is rendered (Weekdays and Days)
        render CalendarWeekdays.new # Template for the weekdays
        render CalendarDays.new # Templates for the day states
      end
    end

    private

    def calendar_attrs
      {
        class: "pk-calendar",
        data: {
          controller: "phlex-kit--calendar",
          phlex_kit__calendar_selected_date_value: @selected_date&.to_s,
          phlex_kit__calendar_min_date_value: @min_date&.to_s,
          phlex_kit__calendar_format_value: @date_format,
          phlex_kit__calendar_phlex_kit__calendar_input_outlet: @input_id
        }
      }
    end
  end
end
