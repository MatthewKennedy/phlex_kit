# frozen_string_literal: true

require "test_helper"

# Audit round 5 (combobox): input-event filtering (paste/IME), the toggle-all
# option's listbox placement + keyboard reachability, token-derived radii, and
# the closePopover popover-target guard.
class Audit5ComboboxTest < Minitest::Test
  include RenderHelper

  COMBOBOX_DIR = File.expand_path("../../app/components/phlex_kit/combobox", __dir__)
  CSS = File.read(File.join(COMBOBOX_DIR, "combobox.css"))
  JS = File.read(File.join(COMBOBOX_DIR, "combobox_controller.js"))

  # --- Finding 1: keyup/search alone misses context-menu paste and IME
  # composition (they fire only `input`) — the popover search field must
  # filter on `input` too, mirroring ComboboxInputTrigger.
  def test_search_input_binds_input_event
    html = render(PhlexKit::ComboboxSearchInput.new(placeholder: "Search…"))
    assert_includes html, "input->phlex-kit--combobox#filterItems"
    assert_includes html, "keyup->phlex-kit--combobox#filterItems" # keep the existing bindings
  end

  # --- Finding 2: keyboard nav must walk the option rows (itemTargets), not
  # the inner selection inputs — the toggle-all row is an option without an
  # "input" target and was unreachable by arrow keys.
  def test_keyboard_nav_walks_item_targets_so_toggle_all_is_reachable
    assert_includes JS, %(this.itemTargets.filter(item => !item.classList.contains("pk-hidden")))
    refute_includes JS, %(this.inputTargets.filter(input => !input.parentElement.classList.contains("pk-hidden")))
  end

  # --- Finding 3: every combobox radius derives from --pk-radius (the three
  # hardcoded `.125rem` values matched the default only by coincidence).
  def test_combobox_css_derives_all_radii_from_the_radius_token
    CSS.scan(/border-radius:\s*([^;]+);/).flatten.each do |value|
      assert_match(/var\(--pk-radius\)/, value, "border-radius `#{value}` must derive from --pk-radius")
    end
  end

  # --- Finding 4: closePopover guarded hasPopoverTarget on one line but
  # dereferenced this.popoverTarget unconditionally two lines later.
  def test_close_popover_guards_popover_target_before_hiding
    assert_includes JS, %(if (this.hasPopoverTarget && this.popoverTarget.matches(":popover-open")) this.popoverTarget.hidePopover())
  end
end
