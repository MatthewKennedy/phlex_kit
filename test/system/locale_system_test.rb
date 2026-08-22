# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# `locale:` browser gate. Everything the calendar controller renders goes
# through Intl with the stamped locale: the caption, the weekday header cells
# (cloned from an English server template), the month dropdown options and each
# day button's accessible name. The command palette's live-region announcement
# comes from the server-stamped templates.
class LocaleSystemTest < SystemTestCase
  include InteractionHelpers

  def test_calendar_caption_uses_the_stamped_locale
    visit "/gallery"
    within("#pk-calendar-locale-fr") do
      assert_selector ".pk-calendar-day", minimum: 28
      assert_equal "janvier", page.evaluate_script(
        "document.querySelector('#pk-calendar-locale-fr [data-phlex-kit--calendar-target=\"monthSelect\"]').selectedOptions[0].textContent.trim()"
      )
    end
  end

  def test_calendar_weekday_headers_use_the_stamped_locale
    visit "/gallery"
    heads = page.evaluate_script(
      "Array.from(document.querySelectorAll('#pk-calendar-locale-fr .pk-calendar-weekday'))" \
      ".map((th) => th.getAttribute('aria-label'))"
    )
    assert_equal %w[lundi mardi mercredi jeudi vendredi samedi dimanche], heads
  end

  def test_calendar_day_accessible_name_uses_the_stamped_locale
    visit "/gallery"
    label = page.evaluate_script(
      "document.querySelector('#pk-calendar-locale-fr .pk-calendar-day.selected').getAttribute('aria-label')"
    )
    assert_includes label, "janvier"
    assert_includes label, "mercredi"
  end

  # The default is the runtime's locale, not a hardcoded en-US — under the
  # en-US test browser that means today's output is unchanged.
  def test_unset_locale_still_renders_english_under_an_en_us_browser
    visit "/gallery"
    title = page.evaluate_script(
      "document.querySelector('.pk-calendar:not([data-phlex-kit--calendar-locale-value]) " \
      ".pk-calendar-title').textContent.trim()"
    )
    assert_match(/\A[A-Z][a-z]+ \d{4}\z/, title)
  end

  # Regression pin (passed on first write — the behavior already existed):
  # the DatePicker seeds its input server-side in Ruby, which has no locale
  # data, so it emits English. The calendar pushes the same date through
  # formatDate() to its outlet on connect, which corrects the language. If
  # that initial push ever stops firing, a localized picker silently shows
  # English until the first pick.
  def test_date_picker_seeded_value_is_reformatted_in_the_stamped_locale
    visit "/gallery"
    value = page.evaluate_script("document.querySelector('#date-fr').value")
    assert_includes value, "janvier"
    assert_includes value, "mercredi"
  end

  def test_command_announcement_uses_the_stamped_templates
    visit "/gallery"
    input = find("#pk-command-locale-fr .pk-command-input")
    input.set("accueil")
    assert_equal "1 résultat(s)", page.evaluate_script(
      "document.querySelector('#pk-command-locale-fr [data-phlex-kit--command-target=\"liveRegion\"]').textContent"
    )

    input.set("zzzz")
    assert_equal "Aucun résultat", page.evaluate_script(
      "document.querySelector('#pk-command-locale-fr [data-phlex-kit--command-target=\"liveRegion\"]').textContent"
    )
  end
end
