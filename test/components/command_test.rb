# frozen_string_literal: true

require "test_helper"

# Command palette — ported from ruby_ui (template-cloned overlay like sheet;
# fuse.js replaced with a substring filter).
class CommandTest < Minitest::Test
  include RenderHelper

  def test_command_dialog_declares_outlet
    html = render(PhlexKit::CommandDialog.new { "x" })
    assert_includes html, "phlex-kit--command-dialog"
    assert_includes html, %(data-phlex-kit--command-dialog-phlex-kit--command-outlet="[data-phlex-kit--command-dialog-instance]")
  end

  def test_trigger_binds_click_and_hotkeys
    html = render(PhlexKit::CommandDialogTrigger.new { "t" })
    assert_includes html, "click->phlex-kit--command-dialog#open"
    assert_includes html, "keydown.meta+k@window->phlex-kit--command-dialog#open"
  end

  def test_dialog_content_is_template_with_instance_marker_and_backdrop
    html = render(PhlexKit::CommandDialogContent.new { "x" })
    assert_includes html, "<template"
    assert_includes html, %(data-controller="phlex-kit--command")
    assert_includes html, "data-phlex-kit--command-dialog-instance"
    assert_includes html, "pk-command-overlay"
    assert_includes html, "click->phlex-kit--command#dismiss"
  end

  def test_dialog_content_size_modifier_fails_loud
    assert_includes render(PhlexKit::CommandDialogContent.new(size: :xl) { "x" }), "pk-command-dialog xl"
    assert_raises(KeyError) { render(PhlexKit::CommandDialogContent.new(size: :giant) { "x" }) }
  end

  def test_input_filters_and_navigates
    html = render(PhlexKit::CommandInput.new)
    assert_includes html, "input->phlex-kit--command#filter"
    assert_includes html, "keydown.esc->phlex-kit--command#dismiss"
    assert_includes html, %(role="combobox")
  end

  def test_group_heading_and_items_role
    html = render(PhlexKit::CommandGroup.new(title: "Pages") { "x" })
    assert_includes html, %(group-heading="Pages")
    assert_includes html, %(role="group")
    assert_includes html, %(data-phlex-kit--command-target="group")
  end

  def test_item_carries_value_and_href
    html = render(PhlexKit::CommandItem.new(value: "settings", href: "/settings") { "Settings" })
    assert_includes html, %(href="/settings")
    assert_includes html, %(data-value="settings")
    assert_includes html, %(role="option")
  end

  def test_empty_state_target
    assert_includes render(PhlexKit::CommandEmpty.new { "No results" }), %(data-phlex-kit--command-target="empty")
  end

  def test_shortcut
    html = render(PhlexKit::CommandShortcut.new { "⌘P" })
    assert_includes html, "pk-command-shortcut"
    assert_includes html, "⌘P"
  end

  def test_separator_is_a_hidden_filter_target
    html = render(PhlexKit::CommandSeparator.new)
    assert_includes html, "pk-command-separator"
    assert_includes html, %(data-phlex-kit--command-target="separator")
    assert_includes html, %(role="separator")
  end

  def test_input_renders_the_pill_structure
    html = render(PhlexKit::CommandInput.new)
    assert_includes html, "pk-command-input-wrapper"
    assert_includes html, "pk-command-input-pill"
    assert_includes html, "pk-command-input-icon"
  end
end
