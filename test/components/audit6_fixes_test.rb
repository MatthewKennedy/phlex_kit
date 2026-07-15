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
end
