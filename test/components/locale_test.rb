# frozen_string_literal: true

require "test_helper"

# `locale:` on Calendar/DatePicker (stamped for the controller's Intl calls)
# and the Command live-region announcement templates.
class LocaleTest < Minitest::Test
  include RenderHelper

  def test_calendar_stamps_locale_value
    html = render(PhlexKit::Calendar.new(locale: "fr-FR"))
    assert_includes html, %(data-phlex-kit--calendar-locale-value="fr-FR")
  end

  def test_calendar_omits_locale_value_when_unset
    html = render(PhlexKit::Calendar.new)
    refute_includes html, "data-phlex-kit--calendar-locale-value"
  end

  def test_date_picker_passes_locale_through_to_calendar
    html = render(PhlexKit::DatePicker.new(id: "due", locale: "de-DE"))
    assert_includes html, %(data-phlex-kit--calendar-locale-value="de-DE")
  end

  def test_command_live_region_carries_default_announcement_templates
    html = render(PhlexKit::Command.new { "x" })
    assert_includes html, %(data-results-format="%{count} result(s)")
    assert_includes html, %(data-no-results-text="No results")
  end

  def test_command_live_region_carries_custom_announcement_templates
    html = render(PhlexKit::Command.new(results_format: "%{count} résultat(s)", no_results_text: "Aucun résultat") { "x" })
    assert_includes html, %(data-results-format="%{count} résultat(s)")
    assert_includes html, %(data-no-results-text="Aucun résultat")
  end
end
