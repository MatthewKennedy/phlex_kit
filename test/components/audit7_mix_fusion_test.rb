# frozen_string_literal: true

require "test_helper"

# Audit round 7 — mix-fusion sweep. Phlex `mix` merges duplicate attrs (space-
# join) instead of overriding, so every generated attr a caller might also
# supply must either be a named kwarg (kit-owned, no caller override) or
# guarded with @attrs.key?/aria_labelled? (caller-overridable default). For
# each site below: (1) a caller override must win cleanly, with no fused
# "a b" value, and (2) the generated default must still render when the
# caller supplies nothing.
class Audit7MixFusionTest < Minitest::Test
  include RenderHelper

  # -- spinner -----------------------------------------------------------

  def test_spinner_default_aria_label
    html = render(PhlexKit::Spinner.new)
    assert_includes html, %(aria-label="Loading")
  end

  def test_spinner_caller_aria_label_overrides_cleanly
    html = render(PhlexKit::Spinner.new(aria: { label: "Saving" }))
    assert_includes html, %(aria-label="Saving")
    refute_includes html, "Loading Saving"
    refute_includes html, "Saving Loading"
  end

  # -- input_otp -----------------------------------------------------------

  def test_input_otp_default_aria_label
    html = render(PhlexKit::InputOtp.new)
    assert_includes html, %(aria-label="One-time code")
  end

  def test_input_otp_caller_aria_label_overrides_cleanly
    html = render(PhlexKit::InputOtp.new(aria: { label: "Verification code" }))
    assert_includes html, %(aria-label="Verification code")
    refute_includes html, "One-time code Verification code"
  end

  # -- chart -----------------------------------------------------------

  def test_chart_default_role
    html = render(PhlexKit::Chart.new)
    assert_includes html, %(role="img")
  end

  def test_chart_caller_role_overrides_cleanly
    html = render(PhlexKit::Chart.new(role: "figure"))
    assert_includes html, %(role="figure")
    refute_includes html, "img figure"
  end

  # -- codeblock -----------------------------------------------------------

  def test_codeblock_default_role_and_tabindex
    html = render(PhlexKit::Codeblock.new("puts 1"))
    assert_includes html, %(role="region")
    assert_includes html, %(tabindex="0")
  end

  def test_codeblock_caller_role_and_tabindex_override_cleanly
    html = render(PhlexKit::Codeblock.new("puts 1", role: "article", tabindex: "-1"))
    assert_includes html, %(role="article")
    assert_includes html, %(tabindex="-1")
    refute_includes html, "region article"
    refute_includes html, "0 -1"
  end

  # -- toast_item -----------------------------------------------------------

  def test_toast_item_default_role_tabindex_aria_atomic
    html = render(PhlexKit::ToastItem.new { "hi" })
    assert_includes html, %(role="status")
    assert_includes html, %(tabindex="0")
    assert_includes html, %(aria-atomic="true")
  end

  def test_toast_item_caller_overrides_role_tabindex_aria_atomic_cleanly
    html = render(PhlexKit::ToastItem.new(role: "log", tabindex: "-1", aria: { atomic: "false" }) { "hi" })
    assert_includes html, %(role="log")
    assert_includes html, %(tabindex="-1")
    assert_includes html, %(aria-atomic="false")
    refute_includes html, "status log"
    refute_includes html, "0 -1"
    refute_includes html, "true false"
  end

  def test_toast_item_error_variant_default_role_alert
    html = render(PhlexKit::ToastItem.new(variant: :error) { "hi" })
    assert_includes html, %(role="alert")
  end

  # -- toast_close -----------------------------------------------------------

  def test_toast_close_default_aria_label
    html = render(PhlexKit::ToastClose.new)
    assert_includes html, %(aria-label="Close toast")
  end

  def test_toast_close_caller_aria_label_overrides_cleanly
    html = render(PhlexKit::ToastClose.new(aria: { label: "Dismiss" }))
    assert_includes html, %(aria-label="Dismiss")
    refute_includes html, "Close toast Dismiss"
  end

  # -- alert_dialog_content -----------------------------------------------------------

  def test_alert_dialog_content_default_role_aria_modal_tabindex
    html = render(PhlexKit::AlertDialogContent.new { "body" })
    assert_includes html, %(role="alertdialog")
    assert_includes html, %(aria-modal="true")
    assert_includes html, %(tabindex="-1")
  end

  def test_alert_dialog_content_caller_overrides_cleanly
    html = render(PhlexKit::AlertDialogContent.new(role: "dialog", "aria-modal": "false", tabindex: "0") { "body" })
    assert_includes html, %(role="dialog")
    assert_includes html, %(aria-modal="false")
    assert_includes html, %(tabindex="0")
    refute_includes html, "alertdialog dialog"
    refute_includes html, "true false"
    refute_includes html, "-1 0"
  end

  def test_alert_dialog_content_caller_overrides_aria_modal_hash_spelling
    html = render(PhlexKit::AlertDialogContent.new(aria: { modal: "false" }) { "body" })
    assert_includes html, %(aria-modal="false")
    refute_includes html, "true false"
  end

  # -- sheet_content -----------------------------------------------------------

  def test_sheet_content_default_role_aria_modal_tabindex
    html = render(PhlexKit::SheetContent.new { "body" })
    assert_includes html, %(role="dialog")
    assert_includes html, %(aria-modal="true")
    assert_includes html, %(tabindex="-1")
  end

  def test_sheet_content_caller_overrides_cleanly
    html = render(PhlexKit::SheetContent.new(role: "region", "aria-modal": "false", tabindex: "0") { "body" })
    assert_includes html, %(role="region")
    assert_includes html, %(aria-modal="false")
    assert_includes html, %(tabindex="0")
    refute_includes html, "dialog region"
    refute_includes html, "true false"
    refute_includes html, "-1 0"
  end

  def test_sheet_content_caller_overrides_aria_modal_hash_spelling
    html = render(PhlexKit::SheetContent.new(aria: { modal: "false" }) { "body" })
    assert_includes html, %(aria-modal="false")
    refute_includes html, "true false"
  end

  # -- drawer_content -----------------------------------------------------------

  def test_drawer_content_default_role_aria_modal_tabindex
    html = render(PhlexKit::DrawerContent.new { "body" })
    assert_includes html, %(role="dialog")
    assert_includes html, %(aria-modal="true")
    assert_includes html, %(tabindex="-1")
  end

  def test_drawer_content_caller_overrides_cleanly
    html = render(PhlexKit::DrawerContent.new(role: "region", "aria-modal": "false", tabindex: "0") { "body" })
    assert_includes html, %(role="region")
    assert_includes html, %(aria-modal="false")
    assert_includes html, %(tabindex="0")
    refute_includes html, "dialog region"
    refute_includes html, "true false"
    refute_includes html, "-1 0"
  end

  def test_drawer_content_caller_overrides_aria_modal_hash_spelling
    html = render(PhlexKit::DrawerContent.new(aria: { modal: "false" }) { "body" })
    assert_includes html, %(aria-modal="false")
    refute_includes html, "true false"
  end

  # -- command_input -----------------------------------------------------------

  def test_command_input_default_empty_value
    html = render(PhlexKit::CommandInput.new)
    assert_includes html, %(value="")
  end

  def test_command_input_caller_value_overrides_cleanly
    html = render(PhlexKit::CommandInput.new(value: "foo"))
    assert_includes html, %(value="foo")
    refute_includes html, %(value=" foo")
  end

  # -- data_table_search -----------------------------------------------------------

  def test_data_table_search_default_method_and_action
    html = render(PhlexKit::DataTableSearch.new(path: "/items"))
    assert_includes html, %(method="get")
    assert_includes html, %(action="/items")
  end

  def test_data_table_search_caller_method_and_action_override_cleanly
    html = render(PhlexKit::DataTableSearch.new(path: "/items", method: "post", action: "/other"))
    assert_includes html, %(method="post")
    assert_includes html, %(action="/other")
    refute_includes html, "get post"
    refute_includes html, "/items /other"
  end

  # -- data_table_per_page_select -----------------------------------------------------------

  def test_data_table_per_page_select_default_method_and_action
    html = render(PhlexKit::DataTablePerPageSelect.new(path: "/items"))
    assert_includes html, %(method="get")
    assert_includes html, %(action="/items")
  end

  def test_data_table_per_page_select_caller_method_and_action_override_cleanly
    html = render(PhlexKit::DataTablePerPageSelect.new(path: "/items", method: "post", action: "/other"))
    assert_includes html, %(method="post")
    assert_includes html, %(action="/other")
    refute_includes html, "get post"
    refute_includes html, "/items /other"
  end
end
