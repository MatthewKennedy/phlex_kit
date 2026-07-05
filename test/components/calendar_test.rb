# frozen_string_literal: true

require "test_helper"

# Calendar — month grid ported from ruby_ui (Mustache replaced with a tiny
# {{key}} interpolator in the phlex-kit--calendar controller).
class CalendarTest < Minitest::Test
  include RenderHelper

  def test_calendar_wires_controller_values_and_outlet
    html = render(PhlexKit::Calendar.new(selected_date: Date.new(2026, 7, 2), min_date: Date.new(2026, 1, 1), input_id: "#due-date"))
    assert_includes html, "phlex-kit--calendar"
    assert_includes html, %(data-phlex-kit--calendar-selected-date-value="2026-07-02")
    assert_includes html, %(data-phlex-kit--calendar-min-date-value="2026-01-01")
    assert_includes html, %(data-phlex-kit--calendar-format-value="yyyy-MM-dd")
    assert_includes html, %(data-phlex-kit--calendar-phlex-kit--calendar-input-outlet="#due-date")
  end

  def test_calendar_renders_header_body_and_templates
    html = render(PhlexKit::Calendar.new)
    assert_includes html, "pk-calendar-title"
    assert_includes html, "click->phlex-kit--calendar#prevMonth"
    assert_includes html, "click->phlex-kit--calendar#nextMonth"
    assert_includes html, %(data-phlex-kit--calendar-target="calendar")
    assert_includes html, %(data-phlex-kit--calendar-target="weekdaysTemplate")
    %w[disabledDateTemplate selectedDateTemplate todayDateTemplate currentMonthDateTemplate otherMonthDateTemplate].each do |t|
      assert_includes html, %(data-phlex-kit--calendar-target="#{t}")
    end
  end

  def test_day_templates_interpolate_and_select
    html = render(PhlexKit::CalendarDays.new)
    assert_includes html, %(data-day="{{day}}")
    assert_includes html, "{{dayDate}}"
    assert_includes html, "click->phlex-kit--calendar#selectDay"
    assert_includes html, "pk-calendar-day selected"
    assert_includes html, %(aria-selected="true")
  end

  def test_weekdays_template_renders_seven_headers
    html = render(PhlexKit::CalendarWeekdays.new)
    assert_equal 7, html.scan("pk-calendar-weekday\"").size
    assert_includes html, %(aria-label="Monday")
  end

  def test_week_numbers_prepend_a_header_column
    html = render(PhlexKit::CalendarWeekdays.new(week_numbers: true))
    assert_includes html, "pk-calendar-weeknumber-head"
    assert_includes html, %(aria-label="Week number")
  end

  def test_range_mode_values
    html = render(PhlexKit::Calendar.new(mode: :range, range_start: "2026-01-12", range_end: "2026-02-11"))
    assert_includes html, %(data-phlex-kit--calendar-mode-value="range")
    assert_includes html, %(range-start-value="2026-01-12")
    assert_includes html, %(range-end-value="2026-02-11")
    assert_includes html, %(view-date-value="2026-01-12")
  end

  def test_multiple_and_disabled_dates_serialize_as_json
    html = render(PhlexKit::Calendar.new(mode: :multiple, selected_dates: %w[2026-06-04 2026-06-09], disabled_dates: %w[2026-06-20]))
    assert_includes html, %(mode-value="multiple")
    assert_includes html, "2026-06-04"
    assert_includes html, "2026-06-20"
  end

  def test_dropdown_caption_renders_native_selects
    html = render(PhlexKit::Calendar.new(caption_layout: :dropdown, from_year: 2024, to_year: 2027))
    assert_includes html, "pk-calendar-dropdown"
    assert_includes html, "phlex-kit--calendar#setMonth"
    assert_includes html, "phlex-kit--calendar#setYear"
    assert_includes html, ">2027</option>"
    refute_includes html, ">2028</option>"
    refute_includes html, "pk-calendar-title"
  end

  def test_unknown_mode_and_caption_fail_loud
    assert_raises(KeyError) { render(PhlexKit::Calendar.new(mode: :nope)) }
    assert_raises(ArgumentError) { render(PhlexKit::Calendar.new(caption_layout: :nope)) }
  end

  def test_day_templates_carry_the_state_hook
    html = render(PhlexKit::CalendarDays.new)
    assert_includes html, "pk-calendar-day {{state}}"
    assert_includes html, "pk-calendar-day selected {{state}}"
    assert_includes html, "pk-calendar-day disabled {{state}}"
  end
end
