# frozen_string_literal: true

require "test_helper"
require "nokogiri"

# Audit round 5 (input/scroller batch) regression tests: masked_input IME
# handling + full-width digit transliteration, and message_scroller viewport
# guards / append classification. Behavior is exercised in the browser suite
# (test/system/audit5_input_scroller_system_test.rb); the source guards here
# keep the fixes from silently regressing without booting Chrome.
class Audit5InputScrollerTest < Minitest::Test
  include RenderHelper

  MASKED_JS = File.read(File.expand_path("../../app/components/phlex_kit/masked_input/masked_input_controller.js", __dir__))
  SCROLLER_JS = File.read(File.expand_path("../../app/components/phlex_kit/message_scroller/message_scroller_controller.js", __dir__))

  # --- Render contracts (unchanged public API) ------------------------------

  def test_masked_input_passes_data_mask_through
    html = render(PhlexKit::MaskedInput.new(data: { mask: "##/##/####" }))
    node = Nokogiri::HTML5.fragment(html).at_css("input.pk-input")
    assert_equal "phlex-kit--masked-input", node["data-controller"]
    assert_equal "##/##/####", node["data-mask"]
  end

  def test_message_scroller_renders_controller_root
    html = render(PhlexKit::MessageScroller.new)
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-message-scroller")
    assert_equal "phlex-kit--message-scroller", node["data-controller"]
  end

  # --- masked_input: IME commit + full-width digits --------------------------

  def test_masked_input_controller_listens_for_compositionend_symmetrically
    assert_includes MASKED_JS, %(addEventListener("compositionend", this.onCompositionEnd)),
      "compositionend must be handled — Safari's final input event still carries isComposing"
    assert_includes MASKED_JS, %(removeEventListener("compositionend", this.onCompositionEnd)),
      "compositionend listener must be removed on disconnect"
  end

  def test_masked_input_controller_transliterates_full_width_digits
    assert_includes MASKED_JS, "０-９",
      "full-width digits (U+FF10–FF19) must be transliterated before the charset filter drops them"
  end

  # --- message_scroller: viewport guards + append classification -------------

  def test_scroller_prepend_scroll_adjustment_is_viewport_guarded
    assert_includes SCROLLER_JS, "this.preserveOnPrependValue && this.hasViewportTarget",
      "history-prepend scrollTop adjustment must not hit the throwing viewportTarget getter"
  end

  def test_scroller_never_optional_chains_the_viewport_target_getter
    refute_match(/viewportTarget\?\./, SCROLLER_JS,
      "Stimulus target getters throw when missing — ?. is dead code; use hasViewportTarget")
  end

  def test_scroller_only_classifies_true_appends_as_appends
    assert_includes SCROLLER_JS, "else if (record.nextSibling === null)",
      "a node inserted between existing rows (both siblings present) must not count as an append"
  end
end
