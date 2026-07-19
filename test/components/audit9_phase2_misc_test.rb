# frozen_string_literal: true

require "test_helper"

# Audit round 9, phase 2 — renderable misc fixes (the JS-only fixes in the same
# batch are gated by system tests / node --check).
class Audit9Phase2MiscTest < Minitest::Test
  include RenderHelper

  # -- aspect_ratio: a caller style HASH must compose with the generated
  #    padding-bottom, not replace it (mix only composes same-typed values). --

  def test_aspect_ratio_string_style_still_carries_padding_bottom
    html = render(PhlexKit::AspectRatio.new(aspect_ratio: "16/9"))
    assert_includes html, "padding-bottom: 56.25%;"
  end

  def test_aspect_ratio_caller_string_style_fuses_cleanly
    html = render(PhlexKit::AspectRatio.new(aspect_ratio: "1/1", style: "border: 1px solid red;"))
    assert_includes html, "padding-bottom: 100.0%;"
    assert_includes html, "border: 1px solid red"
  end

  def test_aspect_ratio_caller_hash_style_preserves_padding_bottom
    html = render(PhlexKit::AspectRatio.new(aspect_ratio: "1/1", style: { color: "red" }))
    # The generated ratio survives alongside the caller's hash declaration.
    assert_includes html, "padding-bottom: 100.0%"
    assert_includes html, "color: red"
  end

  # -- clipboard: a persistent sr-only live region carries the announcement;
  #    the visual popovers are presentational only. --

  def test_clipboard_renders_persistent_sr_only_live_region
    html = render(PhlexKit::Clipboard.new)
    assert_includes html, %(class="pk-sr-only")
    assert_includes html, %(role="status")
    assert_includes html, %(aria-live="polite")
    assert_includes html, %(data-phlex-kit--clipboard-target="liveRegion")
  end

  def test_clipboard_visual_popover_is_presentational_not_a_live_region
    html = render(PhlexKit::ClipboardPopover.new(type: :success) { "Copied!" })
    assert_includes html, %(aria-hidden="true")
    refute_includes html, %(role="status")
  end

  # -- command_empty: server-rendered hidden so it doesn't flash / show with
  #    JS off; the controller reveals it only on a no-match query. --

  def test_command_empty_is_server_rendered_hidden
    html = render(PhlexKit::CommandEmpty.new { "No results" })
    assert_includes html, "pk-command-empty pk-hidden"
  end
end
