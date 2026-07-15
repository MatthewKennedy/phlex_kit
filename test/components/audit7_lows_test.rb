# frozen_string_literal: true

require "test_helper"

# Task 15 — audit round 7 clear-cut lows batch (16 small independent fixes).
# JS-behavioral items (2, 4, 11, 15) get real browser coverage in
# test/system/audit7_lows_system_test.rb; everything render-testable or
# source-scannable lives here.
class Audit7LowsTest < Minitest::Test
  include RenderHelper

  COMMAND_JS = File.read(File.expand_path("../../app/components/phlex_kit/command/command_controller.js", __dir__))
  COMBOBOX_JS = File.read(File.expand_path("../../app/components/phlex_kit/combobox/combobox_controller.js", __dir__))
  INPUT_OTP_JS = File.read(File.expand_path("../../app/components/phlex_kit/input_otp/input_otp_controller.js", __dir__))
  SELECT_JS = File.read(File.expand_path("../../app/components/phlex_kit/select/select_controller.js", __dir__))
  COMBOBOX_CSS = File.read(File.expand_path("../../app/components/phlex_kit/combobox/combobox.css", __dir__))
  INPUT_CSS = File.read(File.expand_path("../../app/components/phlex_kit/input/input.css", __dir__))
  LABEL_CSS = File.read(File.expand_path("../../app/components/phlex_kit/label/label.css", __dir__))
  DATA_TABLE_CSS = File.read(File.expand_path("../../app/components/phlex_kit/data_table/data_table.css", __dir__))

  # --- 1: command focusInput() must not use the `?.` anti-pattern on a
  # Stimulus target getter (throws when absent per CLAUDE.md).
  def test_command_focus_input_guards_has_input_target
    refute_match(/this\.inputTarget\?\.\s*focus\(\)/, COMMAND_JS)
    assert_includes COMMAND_JS, "if (this.hasInputTarget) this.inputTarget.focus();"
  end

  # --- 2: command connect() normalizes stale aria-selected/activedescendant
  # (mirrors select_controller.js's connect()). Behavioral coverage in the
  # system test; this asserts the fix is actually wired into connect().
  def test_command_connect_clears_stale_aria_state
    connect_body = COMMAND_JS[/connect\(\) \{.*?\n  \}/m]
    assert connect_body, "could not find connect() in command_controller.js"
    assert_includes connect_body, %(this.itemTargets.forEach((item) => item.removeAttribute("aria-selected"));)
    assert_includes connect_body, %(this.inputTarget.removeAttribute("aria-activedescendant");)
  end

  # --- 3: diacritics are stripped before fuzzy/substring matching in both
  # command and combobox filtering, without touching result order.
  def test_command_and_combobox_normalize_diacritics
    assert_includes COMMAND_JS, %(.normalize("NFD"))
    assert_includes COMBOBOX_JS, %(.normalize("NFD"))
    # The reorder question is deliberately deferred — the sort comparator
    # must be untouched.
    assert_includes COMMAND_JS, ".sort((a, b) => b.score - a.score)"
  end

  # --- 4: a rejected (non-digit) keystroke into a filled/selected OTP slot
  # must restore the prior value, not blank it or advance focus. Behavioral
  # coverage in the system test; this asserts the restore path exists.
  def test_input_otp_restores_prior_value_on_rejected_keystroke
    assert_includes INPUT_OTP_JS, "slot.dataset.otpValue"
    assert_includes INPUT_OTP_JS, "slot.value = priorValue"
  end

  # --- 5: Switch caller value: must fail loud (checked_value: is the real API).
  def test_switch_rejects_value_kwarg
    error = assert_raises(ArgumentError) { PhlexKit::Switch.new(value: "on") }
    assert_match(/checked_value/, error.message)
  end

  def test_switch_accepts_checked_value
    html = render(PhlexKit::Switch.new(checked_value: "yes"))
    assert_includes html, %(value="yes")
  end

  # --- 6: Link SIZES gains :xs, matching Button's SIZES 1:1.
  def test_link_sizes_matches_button_sizes
    assert_equal PhlexKit::Button::SIZES.keys.sort, PhlexKit::Link::SIZES.keys.sort
    html = render(PhlexKit::Link.new(size: :xs) { "Tiny" })
    assert_includes html, "xs"
  end

  # --- 7: single-type ToggleGroup with nothing selected gives the first
  # enabled item tabindex="0" (roving-tabindex initial stop), not every item
  # defaulting to -1.
  def test_toggle_group_single_no_selection_first_item_gets_tab_stop
    html = render(PhlexKit::ToggleGroup.new(type: :single) { |g|
      g.ToggleGroupItem(value: "left") { "Left" }
      g.ToggleGroupItem(value: "center") { "Center" }
    })
    # data-action attrs contain "->" (a literal ">"), so a [^>]*-bounded regex
    # misfires — every tabindex attr in this markup belongs to an item button.
    tabindexes = html.scan(/tabindex="(-?\d)"/).flatten
    assert_equal [ "0", "-1" ], tabindexes
  end

  def test_toggle_group_single_disabled_first_skips_to_next_enabled
    html = render(PhlexKit::ToggleGroup.new(type: :single) { |g|
      g.ToggleGroupItem(value: "left", disabled: true) { "Left" }
      g.ToggleGroupItem(value: "center") { "Center" }
    })
    tabindexes = html.scan(/tabindex="(-?\d)"/).flatten
    assert_equal [ "-1", "0" ], tabindexes
  end

  # --- 8: pressed: is rejected by ToggleGroupItem (the group derives it).
  def test_toggle_group_item_rejects_pressed_kwarg
    group = PhlexKit::ToggleGroup.new(type: :single)
    error = assert_raises(ArgumentError) { group.ToggleGroupItem(value: "left", pressed: true) { "Left" } }
    assert_match(/pressed/, error.message)
  end

  # --- 9: disabled pager control gets role + aria-disabled (BreadcrumbPage
  # pattern), not a role-less span with just aria-label.
  def test_data_table_pagination_disabled_control_has_role_and_aria_disabled
    html = render(PhlexKit::DataTablePagination.new(page: 1, per_page: 10, total_count: 100))
    assert_match(/class="pk-data-table-page-disabled"[^>]*role="link"[^>]*aria-disabled="true"/, html)
  end

  def test_data_table_pagination_disabled_height_matches_button_neighbors
    assert_includes DATA_TABLE_CSS, ".pk-data-table-page-disabled {\n  display: inline-flex;\n  align-items: center;\n  height: 2rem;"
  end

  # --- 10: the group-heading pseudo-element only renders when data-label is present.
  def test_combobox_group_heading_gated_on_data_label
    assert_includes COMBOBOX_CSS, ".pk-combobox-group[data-label]::before {"
    refute_includes COMBOBOX_CSS, ".pk-combobox-group::before {"
  end

  # --- 11: chip-removal / clear-all focus handoff to the badge input exists.
  def test_combobox_chip_removal_focuses_badge_input
    assert_includes COMBOBOX_JS, "this.badgeInputTarget.focus()"
    assert_includes COMBOBOX_JS, "document.activeElement === remove"
    assert_includes COMBOBOX_JS, "document.activeElement === this.clearButtonTarget"
  end

  # --- 12: disabled input keeps pointer events so cursor: not-allowed shows.
  def test_input_disabled_keeps_pointer_events
    disabled_block = INPUT_CSS[/\.pk-input:disabled \{.*?\}/m]
    refute_match(/pointer-events:\s*none/, disabled_block)
    assert_match(/cursor:\s*not-allowed/, disabled_block)
  end

  # --- 13: label dimming covers BOTH sibling orders.
  def test_label_disabled_dimming_covers_both_sibling_orders
    assert_includes LABEL_CSS, ".pk-label:has(+ :disabled)" # label-first
    assert_includes LABEL_CSS, ":disabled + .pk-label" # control-first
  end

  # --- 14: dir: :ltr explicit must render dir="ltr"; the true default omits it.
  def test_toast_region_explicit_ltr_renders_dir_attribute
    html = render(PhlexKit::ToastRegion.new(dir: :ltr))
    assert_match(/dir="ltr"/, html)
  end

  def test_toast_region_default_omits_dir_attribute
    html = render(PhlexKit::ToastRegion.new)
    refute_match(/dir="/, html)
  end

  def test_toast_region_explicit_rtl_still_renders
    html = render(PhlexKit::ToastRegion.new(dir: :rtl))
    assert_match(/dir="rtl"/, html)
  end

  # --- 15: select trigger wires ArrowDown/ArrowUp to open+highlight when closed.
  def test_select_trigger_wires_arrow_keys
    html = render(PhlexKit::SelectTrigger.new)
    assert_includes html, "keydown.down->phlex-kit--select#handleTriggerArrowDown"
    assert_includes html, "keydown.up->phlex-kit--select#handleTriggerArrowUp"
  end

  def test_select_controller_defines_trigger_arrow_handlers
    assert_includes SELECT_JS, "handleTriggerArrowDown(event)"
    assert_includes SELECT_JS, "handleTriggerArrowUp(event)"
  end

  # --- 16: AttachmentTrigger requires href: when as: :a.
  def test_attachment_trigger_requires_href_for_anchor
    error = assert_raises(ArgumentError) { PhlexKit::AttachmentTrigger.new(as: :a) }
    assert_match(/href/, error.message)
  end

  def test_attachment_trigger_anchor_with_href_renders
    html = render(PhlexKit::AttachmentTrigger.new(as: :a, href: "/file.pdf", aria: { label: "Open" }))
    assert_includes html, %(href="/file.pdf")
  end
end
