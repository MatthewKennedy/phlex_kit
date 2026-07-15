# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5: transient overlays must clear before Turbo snapshots the
# page. Turbo caches at turbo:before-cache — BEFORE Stimulus disconnect —
# so any open dialog / visible flash popover would be resurrected from
# cache. The dummy app doesn't run Turbo; dispatching the event by name
# exercises the same listener a real Turbo visit would.
class TurboCacheSystemTest < SystemTestCase
  include InteractionHelpers

  def dispatch_before_cache
    page.execute_script(%(document.dispatchEvent(new Event("turbo:before-cache"))))
  end

  def test_dialog_closes_and_restores_scroll_on_turbo_before_cache
    visit "/docs/dialog"
    within(demo("Default")) { click_button "Edit profile" }
    assert_selector "dialog.pk-dialog[open]"
    assert_equal "hidden", page.evaluate_script("document.body.style.overflow")

    dispatch_before_cache
    assert_no_selector "dialog.pk-dialog[open]"
    wait_until("body overflow was not restored after turbo:before-cache") do
      page.evaluate_script("document.body.style.overflow") == ""
    end
  end

  def test_clipboard_flash_popover_hides_on_turbo_before_cache
    visit "/docs/clipboard"
    within(demo("Default")) { click_button "Copy" }
    # Success or error (headless clipboard permissions vary) — either popover
    # counts as the transient flash that must not be snapshotted.
    assert_selector ".pk-clipboard-popover:not(.pk-hidden)"

    # Synchronous check: assert_no_selector would wait long enough for the
    # 1.5s auto-hide timer to mask a missing before-cache listener.
    visible_after = page.evaluate_script(<<~JS)
      (() => {
        document.dispatchEvent(new Event("turbo:before-cache"));
        return document.querySelectorAll(".pk-clipboard-popover:not(.pk-hidden)").length;
      })()
    JS
    assert_equal 0, visible_after, "flash popover still visible in the would-be Turbo snapshot"
  end

  # Audit round 5 (same component): a ClipboardSource holding bare text (no
  # child element) must copy that text, not silently flash the error popover.
  def test_clipboard_copies_bare_text_source
    visit "/docs/clipboard"
    section = demo("Default")
    page.execute_script(<<~JS)
      const source = document.querySelector("[data-phlex-kit--clipboard-target='source']");
      source.textContent = "bare text";
      window.__copied = null;
      navigator.clipboard.writeText = (t) => { window.__copied = t; return Promise.resolve(); };
    JS

    within(section) { click_button "Copy" }
    wait_until("bare-text source was not copied") do
      page.evaluate_script("window.__copied") == "bare text"
    end
    assert_selector ".pk-clipboard-popover:not(.pk-hidden)"
  end
end
