# frozen_string_literal: true

require "test_helper"

# Audit round 4 — menu-family findings (menubar, navigation_menu,
# context_menu, dropdown_menu).
class Audit4MenusTest < Minitest::Test
  include RenderHelper

  # -- menubar ---------------------------------------------------------------

  # role="menubar" may only own menuitem children in the accessibility tree —
  # the intermediate .pk-menubar-menu wrapper must be presentational so the
  # tree flattens (axe: required-children).
  def test_menubar_menu_wrapper_is_presentational
    html = render(PhlexKit::MenubarMenu.new { "x" })
    assert_includes html, %(role="none")
  end

  # The panel needs an id so the controller can point the trigger's
  # aria-controls at it (wired in menuTargetConnected, like accordion).
  def test_menubar_content_carries_an_id_for_aria_controls
    html = render(PhlexKit::MenubarContent.new { "items" })
    assert_match(/id="pk-menubar-content-\h{8}"/, html)
  end

  def test_menubar_content_id_is_overridable
    html = render(PhlexKit::MenubarContent.new(id: "my-menu") { "items" })
    assert_includes html, %(id="my-menu")
    refute_includes html, "pk-menubar-content-"
  end

  # The CSS submenu can't be tracked for free, but the sub wrapper's
  # enter/leave + focus events can flip the trigger's aria-expanded.
  def test_menubar_sub_trigger_declares_collapsed_state
    html = render(PhlexKit::MenubarSubTrigger.new { "Share" })
    assert_includes html, %(aria-haspopup="menu")
    assert_includes html, %(aria-expanded="false")
  end

  def test_menubar_sub_syncs_expanded_state_on_hover_and_focus
    html = render(PhlexKit::MenubarSub.new { "x" })
    %w[mouseenter mouseleave focusin focusout].each do |event|
      assert_includes html, "#{event}->phlex-kit--menubar#syncSub"
    end
  end

  # -- navigation_menu ---------------------------------------------------------

  # The nav must wire the shared controller's full keydown handler: it drives
  # arrow-key navigation AND closes on Escape with focus returned to the
  # trigger (the old keydown.esc->close dropped focus to <body>).
  def test_navigation_menu_wires_the_shared_keydown_handler
    html = render(PhlexKit::NavigationMenu.new { "x" })
    assert_includes html, "keydown->phlex-kit--menubar#onKeydown"
    refute_includes html, "keydown.esc->phlex-kit--menubar#close"
  end

  # -- dropdown_menu ---------------------------------------------------------

  # role="menu" allows only menuitem/group/separator children — a heading is
  # invalid. shadcn renders its label as a div.
  def test_dropdown_label_is_a_generic_div
    html = render(PhlexKit::DropdownMenuLabel.new { "My Account" })
    assert_includes html, %(<div class="pk-dropdown-menu-label">)
    refute_includes html, "<h3"
  end

  # `open:` renders the Stimulus value the controller opens from on connect
  # (matching Collapsible's kwarg -> value -> connect flow).
  def test_dropdown_menu_open_kwarg_sets_the_stimulus_value
    html = render(PhlexKit::DropdownMenu.new(open: true) { "x" })
    assert_includes html, "data-phlex-kit--dropdown-menu-open-value"
  end

  def test_dropdown_menu_defaults_closed
    html = render(PhlexKit::DropdownMenu.new { "x" })
    refute_includes html, "open-value"
  end
end
