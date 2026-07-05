# frozen_string_literal: true

require "test_helper"

# Sidebar — the static part set at shadcn/ui parity (no collapsible/trigger/rail).
# The suite can't nest `render`, so each part renders on its own.
class SidebarTest < Minitest::Test
  include RenderHelper

  def test_shell_parts_render_their_elements_and_classes
    {
      PhlexKit::SidebarWrapper => [ "div", "pk-sidebar-wrapper" ],
      PhlexKit::Sidebar => [ "div", "pk-sidebar" ],
      PhlexKit::SidebarHeader => [ "div", "pk-sidebar-header" ],
      PhlexKit::SidebarContent => [ "div", "pk-sidebar-content" ],
      PhlexKit::SidebarFooter => [ "div", "pk-sidebar-footer" ],
      PhlexKit::SidebarGroup => [ "div", "pk-sidebar-group" ],
      PhlexKit::SidebarGroupLabel => [ "div", "pk-sidebar-group-label" ],
      PhlexKit::SidebarGroupContent => [ "div", "pk-sidebar-group-content" ],
      PhlexKit::SidebarGroupAction => [ "button", "pk-sidebar-group-action" ],
      PhlexKit::SidebarMenu => [ "ul", "pk-sidebar-menu" ],
      PhlexKit::SidebarMenuItem => [ "li", "pk-sidebar-menu-item" ],
      PhlexKit::SidebarMenuAction => [ "button", "pk-sidebar-menu-action" ],
      PhlexKit::SidebarMenuBadge => [ "span", "pk-sidebar-menu-badge" ],
      PhlexKit::SidebarMenuSub => [ "ul", "pk-sidebar-menu-sub" ],
      PhlexKit::SidebarMenuSubItem => [ "li", "pk-sidebar-menu-sub-item" ],
      PhlexKit::SidebarInset => [ "main", "pk-sidebar-inset" ]
    }.each do |part, (tag, css)|
      html = render(part.new { "x" })
      assert_includes html, "<#{tag}", "#{part} tag"
      assert_includes html, css, "#{part} class"
    end
  end

  def test_menu_variant_defaults_to_bare_class
    html = render(PhlexKit::Sidebar.new { "x" })
    assert_includes html, %(class="pk-sidebar")
    refute_includes html, "menu-solid"
  end

  def test_menu_solid_adds_modifier
    html = render(PhlexKit::Sidebar.new(menu: :solid) { "x" })
    assert_includes html, "pk-sidebar menu-solid"
  end

  def test_menu_variant_fails_loud
    assert_raises(KeyError) { render(PhlexKit::Sidebar.new(menu: :bogus) { "x" }) }
  end

  def test_parts_pass_attrs_through_mix
    html = render(PhlexKit::Sidebar.new(class: "extra", id: "nav") { "x" })
    assert_includes html, "pk-sidebar extra"
    assert_includes html, %(id="nav")
  end

  def test_menu_button_defaults_to_inactive_button
    html = render(PhlexKit::SidebarMenuButton.new { "Home" })
    assert_includes html, "<button"
    assert_includes html, "pk-sidebar-menu-button"
    assert_includes html, %(data-active="false")
  end

  def test_menu_button_as_anchor_with_active
    html = render(PhlexKit::SidebarMenuButton.new(as: :a, href: "/x", active: true) { "X" })
    assert_includes html, "<a"
    assert_includes html, %(href="/x")
    assert_includes html, %(data-active="true")
  end

  def test_menu_sub_button_defaults_to_anchor
    html = render(PhlexKit::SidebarMenuSubButton.new(href: "/sub") { "Sub" })
    assert_includes html, "<a"
    assert_includes html, "pk-sidebar-menu-sub-button"
    assert_includes html, %(data-active="false")
  end

  def test_menu_sub_button_active_as_button
    html = render(PhlexKit::SidebarMenuSubButton.new(as: :button, active: true) { "Sub" })
    assert_includes html, "<button"
    assert_includes html, %(data-active="true")
  end

  def test_menu_skeleton_renders_text_shimmer_with_random_width
    html = render(PhlexKit::SidebarMenuSkeleton.new)
    assert_includes html, "pk-sidebar-menu-skeleton"
    assert_includes html, "pk-skeleton text"
    assert_match(/--pk-skeleton-width: (5\d|6\d|7\d|8\d|90)%/, html)
    refute_includes html, "pk-skeleton icon"
  end

  def test_menu_skeleton_show_icon
    html = render(PhlexKit::SidebarMenuSkeleton.new(show_icon: true))
    assert_includes html, "pk-skeleton icon"
  end

  def test_separator_wraps_kit_separator
    html = render(PhlexKit::SidebarSeparator.new)
    assert_includes html, "pk-separator"
    assert_includes html, "pk-sidebar-separator"
  end

  def test_input_wraps_kit_input
    html = render(PhlexKit::SidebarInput.new(placeholder: "Search"))
    assert_includes html, "pk-input pk-sidebar-input"
    assert_includes html, %(placeholder="Search")
  end

  def test_wrapper_defaults_to_static_without_controller
    html = render(PhlexKit::SidebarWrapper.new { "x" })
    assert_includes html, %(class="pk-sidebar-wrapper")
    refute_includes html, "collapsible-offcanvas"
    refute_includes html, "data-controller"
    refute_includes html, "pk-sidebar-scrim"
  end

  def test_wrapper_offcanvas_wires_controller_scrim_and_close_actions
    html = render(PhlexKit::SidebarWrapper.new(collapsible: :offcanvas) { "x" })
    assert_includes html, "pk-sidebar-wrapper collapsible-offcanvas"
    assert_includes html, %(data-controller="phlex-kit--sidebar")
    assert_includes html, "keydown.esc@window->phlex-kit--sidebar#closeMobile"
    assert_includes html, "turbo:before-cache@window->phlex-kit--sidebar#closeMobile"
    assert_includes html, "pk-sidebar-scrim"
    assert_includes html, "click->phlex-kit--sidebar#closeMobile"
  end

  def test_wrapper_collapsible_fails_loud
    assert_raises(KeyError) { render(PhlexKit::SidebarWrapper.new(collapsible: :bogus) { "x" }) }
  end

  def test_trigger_renders_menu_icon_and_toggle_action
    html = render(PhlexKit::SidebarTrigger.new)
    assert_includes html, "pk-sidebar-trigger"
    assert_includes html, %(aria-label="Toggle sidebar")
    assert_includes html, "click->phlex-kit--sidebar#toggle"
    assert_includes html, "<svg"
  end

  def test_trigger_block_replaces_default_icon
    html = render(PhlexKit::SidebarTrigger.new { "≡" })
    assert_includes html, "≡"
    refute_includes html, "<svg"
  end

  def test_icon_collapsible_wrapper
    html = render(PhlexKit::SidebarWrapper.new(collapsible: :icon) { "x" })
    assert_includes html, "collapsible-icon"
    assert_includes html, "phlex-kit--sidebar"
    assert_includes html, "keydown.meta+b@window"
    refute_includes html, "data-collapsed"
  end

  def test_default_collapsed_renders_server_side
    html = render(PhlexKit::SidebarWrapper.new(collapsible: :icon, default_collapsed: true) { "x" })
    assert_includes html, "data-collapsed"
  end

  def test_rail_part
    html = render(PhlexKit::SidebarRail.new)
    assert_includes html, "pk-sidebar-rail"
    assert_includes html, "phlex-kit--sidebar#toggle"
  end

  def test_menu_button_tooltip
    html = render(PhlexKit::SidebarMenuButton.new(tooltip: "Dashboard") { "Dashboard" })
    assert_includes html, %(data-tooltip="Dashboard")
  end
end
