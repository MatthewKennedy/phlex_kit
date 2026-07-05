module PhlexKit
  # Calendar (month grid with day selection), ported from ruby_ui's
  # RubyUI::Calendar and extended to shadcn/ui's current calendar surface.
  # Renders the header (title or month/year dropdown caption + prev/next),
  # the <table> the phlex-kit--calendar controller fills, and the <template>s
  # it clones per day state.
  #
  # `mode:` — :single (default), :range (pick start then end;
  # range-start/in-range/range-end day states), or :multiple (toggle days).
  # `selected_date:` / `range_start:`+`range_end:` / `selected_dates:` seed
  # the selection per mode. `min_date:`/`max_date:` clamp; `disabled_dates:`
  # (array of ISO strings or Dates) are unpickable and struck through
  # ("booked"). `week_numbers: true` prepends an ISO week column.
  # `caption_layout: :dropdown` swaps the title for native month/year
  # <select>s (their captionLayout="dropdown"; `from_year:`/`to_year:` bound
  # the year list). Pass `input_id:` a CSS selector (e.g. "#due-date") to
  # push the picked date (or "start – end" range) into a
  # phlex-kit--calendar-input outlet — that's how PhlexKit::DatePicker binds
  # an Input. Sizing rides --pk-cell-size/--pk-cell-radius (calendar.css).
  class Calendar < BaseComponent
    MODES = { single: "single", range: "range", multiple: "multiple" }.freeze
    CAPTION_LAYOUTS = %i[label dropdown].freeze
    MONTHS = %w[January February March April May June July August September October November December].freeze

    def initialize(mode: :single, selected_date: nil, selected_dates: [], range_start: nil, range_end: nil,
                   min_date: nil, max_date: nil, disabled_dates: [], week_numbers: false,
                   caption_layout: :label, from_year: nil, to_year: nil,
                   input_id: nil, date_format: "yyyy-MM-dd", **attrs)
      @mode = MODES.fetch(mode.to_sym)
      @selected_date = selected_date
      @selected_dates = Array(selected_dates).map(&:to_s)
      @range_start = range_start
      @range_end = range_end
      @min_date = min_date
      @max_date = max_date
      @disabled_dates = Array(disabled_dates).map(&:to_s)
      @week_numbers = week_numbers
      @caption_layout = caption_layout.to_sym
      raise ArgumentError, "caption_layout must be :label or :dropdown" unless CAPTION_LAYOUTS.include?(@caption_layout)
      @from_year = from_year
      @to_year = to_year
      @input_id = input_id
      @date_format = date_format
      @attrs = attrs
    end

    def view_template
      div(**mix(calendar_attrs, @attrs)) do
        render CalendarHeader.new do
          if @caption_layout == :dropdown
            render_dropdown_caption
          else
            render CalendarTitle.new
          end
          render CalendarPrev.new
          render CalendarNext.new
        end
        render CalendarBody.new # Where the calendar is rendered (Weekdays and Days)
        render CalendarWeekdays.new(week_numbers: @week_numbers) # Template for the weekdays
        render CalendarDays.new # Templates for the day states
      end
    end

    private

    def render_dropdown_caption
      view_year = parse_year(@selected_date) || parse_year(@range_start) || Time.now.year
      first_year = @from_year || parse_year(@min_date) || (view_year - 10)
      last_year = @to_year || parse_year(@max_date) || (view_year + 10)

      div(class: "pk-calendar-dropdowns") do
        select(
          class: "pk-native-select-field pk-calendar-dropdown",
          aria: { label: "Month" },
          data: { phlex_kit__calendar_target: "monthSelect", action: "change->phlex-kit--calendar#setMonth" }
        ) do
          MONTHS.each_with_index { |name, index| option(value: index.to_s) { name } }
        end
        select(
          class: "pk-native-select-field pk-calendar-dropdown",
          aria: { label: "Year" },
          data: { phlex_kit__calendar_target: "yearSelect", action: "change->phlex-kit--calendar#setYear" }
        ) do
          (first_year..last_year).each { |year| option(value: year.to_s) { year.to_s } }
        end
      end
    end

    def parse_year(value)
      value.to_s[/\A(\d{4})/, 1]&.to_i
    end

    def calendar_attrs
      data = {
        controller: "phlex-kit--calendar",
        phlex_kit__calendar_mode_value: @mode,
        phlex_kit__calendar_selected_date_value: @selected_date&.to_s,
        phlex_kit__calendar_min_date_value: @min_date&.to_s,
        phlex_kit__calendar_max_date_value: @max_date&.to_s,
        phlex_kit__calendar_format_value: @date_format,
        phlex_kit__calendar_phlex_kit__calendar_input_outlet: @input_id
      }
      data[:phlex_kit__calendar_range_start_value] = @range_start.to_s if @range_start
      data[:phlex_kit__calendar_range_end_value] = @range_end.to_s if @range_end
      data[:phlex_kit__calendar_selected_dates_value] = JSON.generate(@selected_dates) if @selected_dates.any?
      data[:phlex_kit__calendar_disabled_dates_value] = JSON.generate(@disabled_dates) if @disabled_dates.any?
      data[:phlex_kit__calendar_week_numbers_value] = "true" if @week_numbers
      # Seed the view on the selection so the grid opens on the right month.
      view_seed = @selected_date || @range_start || @selected_dates.first
      data[:phlex_kit__calendar_view_date_value] = view_seed.to_s if view_seed

      { class: "pk-calendar", data: data }
    end
  end
end
