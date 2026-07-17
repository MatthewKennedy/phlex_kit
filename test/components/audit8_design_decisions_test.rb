# frozen_string_literal: true

require "test_helper"

# Audit round 8: the deferred design decisions, approved 2026-07-17.
# Link rel="noopener" default, data_table selection-summary i18n format,
# Checkbox include_hidden (Rails idiom), Progress indeterminate mode.
class Audit8DesignDecisionsTest < Minitest::Test
  include RenderHelper

  # --- Link: rel="noopener" defaults on target="_blank" ---------------------

  def test_link_with_blank_target_defaults_rel_noopener
    html = render(PhlexKit::Link.new(href: "https://example.com", target: "_blank") { "out" })
    assert_includes html, %(rel="noopener")
  end

  def test_link_without_target_gets_no_rel
    html = render(PhlexKit::Link.new(href: "/home") { "home" })
    refute_includes html, "rel="
  end

  def test_link_caller_rel_wins_without_fusing
    html = render(PhlexKit::Link.new(href: "https://example.com", target: "_blank", rel: "external") { "out" })
    assert_includes html, %(rel="external")
    refute_includes html, "noopener"
  end

  # --- data_table selection summary: format template -------------------------

  def test_selection_summary_renders_default_format_and_stamps_it
    html = render(PhlexKit::DataTableSelectionSummary.new(total_on_page: 5))
    assert_includes html, "0 of 5 row(s) selected."
    assert_includes html, %(data-format="%{selected} of %{total} row(s) selected.")
  end

  def test_selection_summary_renders_custom_format
    html = render(PhlexKit::DataTableSelectionSummary.new(
      total_on_page: 3, format: "%{selected} sur %{total} ligne(s) sélectionnée(s)."
    ))
    assert_includes html, "0 sur 3 ligne(s) sélectionnée(s)."
    assert_includes html, %(data-format="%{selected} sur %{total} ligne(s) sélectionnée(s).")
  end

  # --- Checkbox: include_hidden (Rails check_box idiom) ----------------------

  def test_checkbox_with_name_emits_hidden_unchecked_field
    html = render(PhlexKit::Checkbox.new(name: "terms"))
    assert_includes html, %(<input type="hidden" name="terms" value="0">)
    # hidden comes first so a checked box's value wins in the params
    assert_operator html.index("hidden"), :<, html.index("checkbox")
  end

  def test_checkbox_hidden_field_disabled_in_lockstep
    html = render(PhlexKit::Checkbox.new(name: "terms", disabled: true))
    assert_includes html, %(<input type="hidden" name="terms" value="0" disabled>)
  end

  def test_checkbox_include_hidden_false_and_nameless_skip_the_hidden_field
    refute_includes render(PhlexKit::Checkbox.new(name: "terms", include_hidden: false)), "hidden"
    refute_includes render(PhlexKit::Checkbox.new), "hidden"
  end

  def test_checkbox_array_name_never_emits_hidden_field
    # An unchecked "0" would inject a bogus element into the ids[] param.
    html = render(PhlexKit::Checkbox.new(name: "ids[]", value: "7"))
    refute_includes html, "hidden"
  end

  def test_checkbox_custom_unchecked_value
    html = render(PhlexKit::Checkbox.new(name: "terms", unchecked_value: "no"))
    assert_includes html, %(<input type="hidden" name="terms" value="no">)
  end

  # --- Progress: indeterminate mode ------------------------------------------

  def test_progress_value_nil_renders_indeterminate
    html = render(PhlexKit::Progress.new(value: nil))
    assert_includes html, %(class="pk-progress indeterminate")
    assert_includes html, %(data-state="indeterminate")
    # ARIA: a progressbar with unknown value carries NO aria-valuenow
    refute_includes html, "aria-valuenow"
    refute_includes html, "aria-valuetext"
  end

  def test_progress_indeterminate_accepts_value_text
    html = render(PhlexKit::Progress.new(value: nil, value_text: "Loading…"))
    assert_includes html, %(aria-valuetext="Loading…")
  end

  def test_progress_numeric_value_unchanged
    html = render(PhlexKit::Progress.new(value: 40))
    assert_includes html, %(aria-valuenow="40")
    assert_includes html, %(aria-valuetext="40%")
    assert_includes html, "--pk-progress-value: 40;"
    refute_includes html, "indeterminate"
  end
end
