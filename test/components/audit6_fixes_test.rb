# frozen_string_literal: true

require "test_helper"
require "nokogiri"

# Audit round 6 regression tests. Phase 1: generated ids must be named kwargs,
# not mix defaults — `mix` merges a caller id with the generated one into an
# invalid two-token id ("pk-tabs-trigger-a my-tab"), breaking aria-controls /
# aria-labelledby pre-JS and the controllers' derived option/result ids.
# Same class of bug as SelectContent's (audit round 5, finding 5b).
class Audit6FixesTest < Minitest::Test
  include RenderHelper

  # --- Finding 1a: TabsTrigger caller id must win, unfused.
  def test_tabs_trigger_caller_id_wins_unfused
    html = render(PhlexKit::TabsTrigger.new(value: "a", id: "my-tab")) { "Tab" }
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-tabs-trigger")
    assert_equal "my-tab", node["id"]
  end

  def test_tabs_trigger_keeps_deterministic_id_when_caller_omits_it
    html = render(PhlexKit::TabsTrigger.new(value: "a")) { "Tab" }
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-tabs-trigger")
    assert_equal "pk-tabs-trigger-a", node["id"]
  end

  # --- Finding 1b: TabsContent caller id must win, unfused.
  def test_tabs_content_caller_id_wins_unfused
    html = render(PhlexKit::TabsContent.new(value: "a", id: "my-panel")) { "Panel" }
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-tabs-content")
    assert_equal "my-panel", node["id"]
  end

  def test_tabs_content_keeps_deterministic_id_when_caller_omits_it
    html = render(PhlexKit::TabsContent.new(value: "a")) { "Panel" }
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-tabs-content")
    assert_equal "pk-tabs-panel-a", node["id"]
  end

  # --- Finding 1c: ComboboxList caller id must win, unfused. The component's
  # own docs direct callers to set this id for static list_id: wiring.
  def test_combobox_list_caller_id_wins_unfused
    html = render(PhlexKit::ComboboxList.new(id: "cb-list") { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-combobox-list")
    assert_equal "cb-list", node["id"]
  end

  def test_combobox_list_generates_id_when_caller_omits_it
    html = render(PhlexKit::ComboboxList.new { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-combobox-list")
    assert_match(/\Apk-combobox-list-\h{8}\z/, node["id"])
  end

  # --- Finding 1d: CommandList caller id must win, unfused.
  def test_command_list_caller_id_wins_unfused
    html = render(PhlexKit::CommandList.new(id: "cmd-list") { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-command-list")
    assert_equal "cmd-list", node["id"]
  end

  def test_command_list_generates_id_when_caller_omits_it
    html = render(PhlexKit::CommandList.new { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-command-list")
    assert_match(/\Apk-command-list-\h{8}\z/, node["id"])
  end

  # --- Phase 3: slider.css strips the native outline for ALL browsers but
  # only reinstated the kit focus ring on the -webkit thumb — Firefox
  # keyboard users got no focus indicator at all. Cuprite can't drive
  # Firefox, so guard the -moz rule's presence mechanically.
  def test_slider_css_reinstates_focus_ring_on_moz_range_thumb
    css = File.read(File.expand_path("../../app/components/phlex_kit/slider/slider.css", __dir__))
    moz_focus = css[/\.pk-slider:focus-visible::-moz-range-thumb\s*\{[^}]*\}/m]
    refute_nil moz_focus, "slider.css removes the native outline but has no :focus-visible::-moz-range-thumb replacement ring"
    assert_match(/box-shadow:\s*0 0 0 3px color-mix\(in oklab, var\(--pk-ring\) 50%, transparent\)/, moz_focus)
  end

  # --- Phase 5: `as:` is dispatched via send — every component doing that
  # must validate against an AS_TAGS allowlist (round-5 convention:
  # Separator/Marker/BubbleContent) instead of silently coercing or reaching
  # arbitrary (including private) methods.
  def test_heading_as_rejects_unknown_tags
    error = assert_raises(ArgumentError) { PhlexKit::Heading.new(as: :element) }
    assert_match(/as/i, error.message)
  end

  def test_heading_as_still_renders_documented_tags
    html = render(PhlexKit::Heading.new(level: 2, as: :p)) { "T" }
    assert_includes html, "<p"
  end

  def test_text_as_rejects_unknown_tags
    error = assert_raises(ArgumentError) { PhlexKit::Text.new(as: :classes) }
    assert_match(/as/i, error.message)
  end

  def test_text_as_still_renders_documented_tags
    html = render(PhlexKit::Text.new(as: :span)) { "T" }
    assert_includes html, "<span"
  end

  def test_tabs_trigger_as_rejects_unknown_tags
    assert_raises(ArgumentError) { PhlexKit::TabsTrigger.new(value: "a", as: :div) }
  end

  def test_attachment_trigger_as_rejects_unknown_tags
    assert_raises(ArgumentError) { PhlexKit::AttachmentTrigger.new(as: :div) }
  end

  def test_sidebar_menu_button_as_rejects_unknown_tags
    assert_raises(ArgumentError) { PhlexKit::SidebarMenuButton.new(as: :div) }
  end

  # A String as: (config/DB-sourced) must behave like the Symbol — the old
  # bare-send rendered the <a> but failed the `@as == :a` comparison, so an
  # active link silently lost aria-current="page".
  def test_sidebar_menu_button_string_as_keeps_aria_current
    html = render(PhlexKit::SidebarMenuButton.new(as: "a", href: "/x", active: true)) { "Home" }
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-sidebar-menu-button")
    assert_equal "a", node.name
    assert_equal "page", node["aria-current"]
  end

  def test_sidebar_menu_sub_button_as_rejects_unknown_tags
    assert_raises(ArgumentError) { PhlexKit::SidebarMenuSubButton.new(as: :div) }
  end

  # --- Phase 5: Message align: silently accepted unknown values ( :right
  # rendered an unstyled data-align) while sibling Bubble fails loud on the
  # identical kwarg.
  def test_message_align_rejects_unknown_values
    assert_raises(KeyError) { PhlexKit::Message.new(align: :right) }
  end

  def test_message_align_accepts_start_and_end
    html = render(PhlexKit::Message.new(align: :end) { })
    assert_includes html, %(data-align="end")
  end

  # --- Phase 6: component-generated attributes must not fuse with a caller's
  # copy through mix (pattern: SelectContent's id, round 5).
  def test_icon_caller_width_and_height_override_size_default
    html = render(PhlexKit::Icon.new(:check, width: "24"))
    node = Nokogiri::HTML5.fragment(html).at_css("svg")
    assert_equal "24", node["width"]
    assert_equal "16", node["height"], "height should keep the size: default when only width is overridden"
  end

  def test_icon_caller_aria_hidden_override_wins_unfused
    html = render(PhlexKit::Icon.new(:check, "aria-hidden": "false"))
    node = Nokogiri::HTML5.fragment(html).at_css("svg")
    assert_equal "false", node["aria-hidden"]
  end

  def test_scroll_area_caller_role_wins_over_region_default
    html = render(PhlexKit::ScrollArea.new(role: "log", aria: { label: "Chat" }) { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-scroll-area")
    assert_equal "log", node["role"]
  end

  def test_scroll_area_caller_tabindex_wins_unfused
    html = render(PhlexKit::ScrollArea.new(tabindex: "-1") { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-scroll-area")
    assert_equal "-1", node["tabindex"]
  end

  def test_pagination_label_kwarg_and_caller_aria_label_win_unfused
    html = render(PhlexKit::Pagination.new(label: "Results") { })
    assert_includes html, %(aria-label="Results")

    html = render(PhlexKit::Pagination.new(aria: { label: "Résultats" }) { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-pagination")
    assert_equal "Résultats", node["aria-label"]
  end

  def test_pagination_next_caller_aria_label_wins_unfused
    html = render(PhlexKit::PaginationNext.new(href: "#", aria: { label: "Nächste" }))
    node = Nokogiri::HTML5.fragment(html).at_css("a")
    assert_equal "Nächste", node["aria-label"]
  end

  def test_pagination_previous_caller_aria_label_wins_unfused
    html = render(PhlexKit::PaginationPrevious.new(href: "#", aria: { label: "Vorherige" }))
    node = Nokogiri::HTML5.fragment(html).at_css("a")
    assert_equal "Vorherige", node["aria-label"]
  end

  def test_marker_caller_type_wins_unfused
    html = render(PhlexKit::Marker.new(as: :button, type: "submit") { "Go" })
    node = Nokogiri::HTML5.fragment(html).at_css("button.pk-marker")
    assert_equal "submit", node["type"]
  end

  def test_marker_href_with_conflicting_as_raises
    assert_raises(ArgumentError) { PhlexKit::Marker.new(href: "/x", as: :button) }
  end

  # --- Phase 7: server-rendered state and static a11y attributes.

  # collapsible.css keys the chevron rotation on [data-state="open"], which
  # only connect() stamped — open: true rendered a closed-pointing chevron
  # pre-JS (the tabs bug, pattern 4).
  def test_collapsible_server_renders_data_state
    html = render(PhlexKit::Collapsible.new(open: true) { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-collapsible")
    assert_equal "open", node["data-state"]

    html = render(PhlexKit::Collapsible.new { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-collapsible")
    assert_equal "closed", node["data-state"]
  end

  # role="separator" is implicitly horizontal — a non-decorative vertical
  # separator announced the wrong axis without aria-orientation.
  def test_separator_non_decorative_vertical_gets_aria_orientation
    html = render(PhlexKit::Separator.new(orientation: :vertical, decorative: false))
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-separator")
    assert_equal "vertical", node["aria-orientation"]

    html = render(PhlexKit::Separator.new(orientation: :vertical))
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-separator")
    assert_nil node["aria-orientation"], "decorative separators (role=none) must not carry aria-orientation"
  end

  # Accordion trigger stripped background/border but never reinstated the kit
  # focus ring — keyboard focus fell back to the UA outline.
  def test_accordion_trigger_has_kit_focus_ring
    css = File.read(File.expand_path("../../app/components/phlex_kit/accordion/accordion.css", __dir__))
    ring = css[/\.pk-accordion-trigger:focus-visible\s*\{[^}]*\}/m]
    refute_nil ring, "accordion.css has no .pk-accordion-trigger:focus-visible rule"
    assert_match(/box-shadow:\s*0 0 0 3px color-mix\(in oklab, var\(--pk-ring\) 50%, transparent\)/, ring)
  end

  # The option label is the interactive surface (ARIA option) — the real
  # input must not be a second tab stop. ComboboxCheckbox/Radio already set
  # this; the toggle-all checkbox was missed.
  def test_combobox_toggle_all_checkbox_is_not_a_tab_stop
    html = render(PhlexKit::ComboboxToggleAllCheckbox.new)
    node = Nokogiri::HTML5.fragment(html).at_css("input")
    assert_equal "-1", node["tabindex"]
  end

  # Options in an aria-activedescendant listbox must not be tab stops —
  # every CommandItem anchor was tabbable (and disabled ones focusable).
  def test_command_item_is_not_a_tab_stop
    html = render(PhlexKit::CommandItem.new(value: "a", text: "A") { "A" })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-command-item")
    assert_equal "-1", node["tabindex"]
  end

  # A CSS-revealed submenu with aria-haspopup but no aria-expanded gives AT
  # no open/closed state; the false default must be server-rendered (the
  # controller mirrors it live, like menubar's syncSub).
  def test_dropdown_sub_trigger_server_renders_aria_expanded_false
    html = render(PhlexKit::DropdownMenuSubTrigger.new { "More" })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-dropdown-menu-sub-trigger")
    assert_equal "false", node["aria-expanded"]
  end

  def test_dropdown_sub_wires_sync_actions
    html = render(PhlexKit::DropdownMenuSub.new { })
    node = Nokogiri::HTML5.fragment(html).at_css(".pk-dropdown-menu-sub")
    assert_includes node["data-action"].to_s, "syncSub"
  end
end
