# frozen_string_literal: true

require "test_helper"

# Audit round 10 — server-side guards for the round-10 findings that live in
# Ruby: PopoverContent's `popover:` mix-fusion guard, TableHead's overridable
# `scope="col"` default, and the ToggleGroup disabled wiring the controller
# reads to keep a disabled group's rebuilt hidden input non-submitting.
class Audit10FixesTest < Minitest::Test
  include RenderHelper

  # Finding 5: a caller `popover:` must OVERRIDE, not fuse into "auto manual"
  # (which the browser normalizes to manual, killing native light-dismiss).
  def test_popover_content_default_popover_auto
    html = render(PhlexKit::PopoverContent.new { "x" })
    assert_includes html, 'popover="auto"'
  end

  def test_popover_content_caller_popover_overrides_without_fusing
    html = render(PhlexKit::PopoverContent.new(popover: "manual") { "x" })
    assert_includes html, 'popover="manual"'
    refute_includes html, "auto manual"
  end

  # Finding 8: TableHead defaults scope="col" (header-row common case) but a
  # caller's scope: must win cleanly, not fuse into "col row".
  def test_table_head_default_scope_col
    html = render(PhlexKit::TableHead.new { "Name" })
    assert_includes html, 'scope="col"'
  end

  def test_table_head_caller_scope_overrides_without_fusing
    html = render(PhlexKit::TableHead.new(scope: "row") { "Name" })
    assert_includes html, 'scope="row"'
    refute_includes html, "col row"
  end

  # Finding 3: the disabled flag the controller's disabledValue reads, plus the
  # server-rendered `disabled` hidden input it must preserve on reconcile.
  def test_disabled_toggle_group_exposes_disabled_value_and_input
    html = render(PhlexKit::ToggleGroup.new(type: :single, name: "align", value: "left", disabled: true))
    assert_includes html, 'data-phlex-kit--toggle-group-disabled-value="true"'
    assert_match(/<input[^>]*type="hidden"[^>]*disabled/, html)
  end

  def test_enabled_toggle_group_disabled_value_false
    html = render(PhlexKit::ToggleGroup.new(type: :single, name: "align", value: "left"))
    assert_includes html, 'data-phlex-kit--toggle-group-disabled-value="false"'
  end

  # Finding 2: the invalid-radio focus ring override must exist (equal to the
  # checkbox recipe) — without it the always-on invalid ring swallows the
  # keyboard focus indicator (WCAG 2.4.7). Guards against silent deletion.
  def test_radio_invalid_focus_ring_override_present
    css = File.read(File.expand_path("../../app/components/phlex_kit/radio_button/radio_button.css", __dir__))
    assert_includes css, '.pk-radio[aria-invalid="true"]:focus-visible'
    assert_includes css, ':root[data-theme="light"] .pk-radio[aria-invalid="true"]:focus-visible'
    assert_includes css, ':root[data-theme="system"] .pk-radio[aria-invalid="true"]:focus-visible'
  end
end
