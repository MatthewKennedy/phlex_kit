# frozen_string_literal: true

require "test_helper"

# Audit round 4 — calendar family (calendar, date_picker, carousel, resizable):
# valid ARIA grid pattern, accessible day names, server-side dropdown/input
# seeding, selector escaping, orientation-aware keys, style attr joining.
class Audit4CalendarFamilyTest < Minitest::Test
  include RenderHelper

  # -- calendar: ARIA grid pattern (finding 1) ------------------------------

  # The day grid must be a real grid: table role="grid". Previously the day
  # buttons carried role="gridcell" inside td role="presentation" with no
  # grid ancestor — invalid ARIA.
  def test_calendar_body_is_a_grid
    html = render(PhlexKit::CalendarBody.new)
    assert_includes html, %(role="grid")
  end

  def test_day_template_cells_are_gridcells_not_the_buttons
    html = render(PhlexKit::CalendarDays.new)
    # the td is the gridcell…
    assert_match(/<td[^>]+role="gridcell"/, html)
    # …and the button inside is a plain button
    refute_match(/<button[^>]+role="gridcell"/, html)
    refute_match(/<td[^>]+role="presentation"/, html)
  end

  def test_selected_template_puts_aria_selected_on_the_gridcell
    html = render(PhlexKit::CalendarDays.new)
    assert_match(/<td[^>]+aria-selected="true"/, html)
    refute_match(/<button[^>]+aria-selected/, html)
  end

  def test_weekday_header_row_has_row_role
    html = render(PhlexKit::CalendarWeekdays.new)
    assert_match(/<tr[^>]+role="row"/, html)
  end

  # -- calendar: accessible day names (finding 2) ---------------------------

  def test_day_templates_carry_a_full_date_label_placeholder
    html = render(PhlexKit::CalendarDays.new)
    # every one of the five day templates names the day with the full date
    assert_equal 5, html.scan(%(aria-label="{{dayLabel}}")).size
  end

  # -- calendar: dropdown caption server-side selection (finding 4) ---------

  def test_dropdown_caption_selects_the_view_month_and_year_at_render
    html = render(PhlexKit::Calendar.new(
      caption_layout: :dropdown, selected_date: Date.new(2026, 7, 2),
      from_year: 2024, to_year: 2027
    ))
    assert_match(%r{<option value="6" selected>July</option>}, html)
    assert_match(%r{<option value="2026" selected>2026</option>}, html)
    refute_match(%r{<option value="0" selected>}, html)
  end

  def test_dropdown_caption_selects_from_range_start_seed
    html = render(PhlexKit::Calendar.new(
      caption_layout: :dropdown, mode: :range, range_start: "2025-11-12",
      from_year: 2024, to_year: 2027
    ))
    assert_match(%r{<option value="10" selected>November</option>}, html)
    assert_match(%r{<option value="2025" selected>2025</option>}, html)
  end

  # -- calendar: month bound nav buttons are targets (finding 3) ------------

  def test_prev_and_next_buttons_are_controller_targets_for_bound_clamping
    prev = render(PhlexKit::CalendarPrev.new)
    nxt = render(PhlexKit::CalendarNext.new)
    assert_includes prev, %(data-phlex-kit--calendar-target="prevButton")
    assert_includes nxt, %(data-phlex-kit--calendar-target="nextButton")
  end

  # -- date_picker: initial value uses date_format (finding 9) --------------

  def test_date_picker_seeds_input_with_the_formatted_date
    html = render(PhlexKit::DatePicker.new(
      id: "d", selected_date: Date.new(2026, 7, 2), date_format: "dd/MM/yyyy"
    ))
    assert_includes html, %(value="02/07/2026")
    refute_match(/<input[^>]+value="2026-07-02"/, html)
    # the calendar still receives the ISO date for its own state
    assert_includes html, %(data-phlex-kit--calendar-selected-date-value="2026-07-02")
  end

  def test_date_picker_formats_long_tokens
    html = render(PhlexKit::DatePicker.new(
      id: "d", selected_date: "2026-07-02", date_format: "EEEE, MMMM do, yyyy"
    ))
    assert_includes html, %(value="Thursday, July 2nd, 2026")
  end

  def test_date_picker_explicit_value_wins_over_formatting
    html = render(PhlexKit::DatePicker.new(id: "d", value: "raw", selected_date: Date.new(2026, 7, 2)))
    assert_includes html, %(value="raw")
  end

  # -- date_picker: CSS-selector-safe outlet id (finding 10) ----------------

  def test_date_picker_outlet_uses_attribute_selector_for_unsafe_ids
    html = render(PhlexKit::DatePicker.new(id: "user:due.date"))
    assert_includes html, %(data-phlex-kit--calendar-phlex-kit--calendar-input-outlet="[id=&quot;user:due.date&quot;]")
  end

  def test_date_picker_outlet_keeps_the_id_selector_for_safe_ids
    html = render(PhlexKit::DatePicker.new(id: "due-date"))
    assert_includes html, %(data-phlex-kit--calendar-phlex-kit--calendar-input-outlet="#due-date")
  end

  # -- carousel: orientation-aware keyboard (finding 14) --------------------

  def test_horizontal_carousel_uses_left_right_keys
    html = render(PhlexKit::Carousel.new { "x" })
    assert_includes html, "keydown.right->phlex-kit--carousel#scrollNext:prevent"
    assert_includes html, "keydown.left->phlex-kit--carousel#scrollPrev:prevent"
    refute_includes html, "keydown.down"
  end

  def test_vertical_carousel_uses_up_down_keys
    html = render(PhlexKit::Carousel.new(orientation: :vertical) { "x" })
    assert_includes html, "keydown.down->phlex-kit--carousel#scrollNext:prevent"
    assert_includes html, "keydown.up->phlex-kit--carousel#scrollPrev:prevent"
    refute_includes html, "keydown.right"
  end

  # -- resizable: style attr must survive a caller style (correction) -------

  def test_resizable_panel_style_joins_validly_with_caller_style
    html = render(PhlexKit::ResizablePanel.new(default_size: 50, style: "min-width: 100px;") { "x" })
    # Phlex mix joins string attrs with a space — without a trailing ";" the
    # two declarations fuse into invalid CSS ("flex-grow: 50 min-width…").
    assert_includes html, %(style="flex-grow: 50; min-width: 100px;")
  end
end
