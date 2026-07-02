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
end
