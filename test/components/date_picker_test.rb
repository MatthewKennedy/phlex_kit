# frozen_string_literal: true

require "test_helper"

# DatePicker — Calendar in a Popover bound to an Input, ported from ruby_ui.
class DatePickerTest < Minitest::Test
  include RenderHelper

  def test_binds_input_to_calendar_via_outlet
    html = render(PhlexKit::DatePicker.new(id: "due-date", name: "due_date"))
    assert_includes html, %(id="due-date")
    assert_includes html, %(name="due_date")
    assert_includes html, %(data-controller="phlex-kit--calendar-input")
    assert_includes html, %(data-phlex-kit--calendar-phlex-kit--calendar-input-outlet="#due-date")
  end

  def test_composes_popover_and_calendar
    html = render(PhlexKit::DatePicker.new(id: "d"))
    assert_includes html, "phlex-kit--popover"
    assert_includes html, "pk-popover-content"
    assert_includes html, "phlex-kit--calendar"
    assert_includes html, "Select a date"
  end

  def test_generates_an_id_and_seeds_selected_date
    html = render(PhlexKit::DatePicker.new(selected_date: Date.new(2026, 7, 2)))
    assert_match(/id="date-picker-\h{8}"/, html)
    assert_includes html, %(value="2026-07-02")
    assert_includes html, %(data-phlex-kit--calendar-selected-date-value="2026-07-02")
  end

  def test_label_omitted_when_nil
    refute_includes render(PhlexKit::DatePicker.new(id: "d", label: nil)), "pk-date-picker-label"
  end
end
