# frozen_string_literal: true

require "test_helper"

# Audit round 4 — modal family + sidebar markup contracts:
# - AlertDialogContent forwards caller attrs to the visible panel, not the
#   inert <template> wrapper.
# - SidebarTrigger/SidebarRail expose aria-expanded (server-rendered initial
#   state) and aria-controls.
# - SidebarMenuButton emits aria-current="page" on active links, aria-label
#   from tooltip: (accessible name survives the icon-collapsed rail), and
#   wraps bare block text in a <span> so the collapsed rail's
#   `> :not(svg)` rule can hide it.
class Audit4ModalsTest < Minitest::Test
  include RenderHelper

  # --- Finding 4: AlertDialogContent caller attrs land on the panel ---------

  def test_alert_dialog_content_attrs_land_on_panel_not_template
    html = render(PhlexKit::AlertDialogContent.new(class: "my-panel", id: "confirm") { "body" })
    panel = html[/<div[^>]*role="alertdialog"[^>]*>/]
    template = html[/<template[^>]*>/]
    refute_nil panel
    assert_includes panel, "my-panel"
    assert_includes panel, %(id="confirm")
    assert_includes panel, "pk-alert-dialog-panel"
    refute_includes template, "my-panel"
    refute_includes template, %(id="confirm")
  end

  def test_alert_dialog_content_template_keeps_target_attribute
    html = render(PhlexKit::AlertDialogContent.new { "body" })
    template = html[/<template[^>]*>/]
    assert_includes template, %(data-phlex-kit--alert-dialog-target="content")
  end

  # --- Finding 10: trigger + rail expose expanded/controls state ------------

  def test_sidebar_trigger_renders_aria_expanded_true_by_default
    html = render(PhlexKit::SidebarTrigger.new)
    assert_includes html, %(aria-expanded="true")
  end

  def test_sidebar_trigger_renders_aria_expanded_false_when_collapsed
    html = render(PhlexKit::SidebarTrigger.new(expanded: false))
    assert_includes html, %(aria-expanded="false")
  end

  def test_sidebar_trigger_renders_aria_controls
    html = render(PhlexKit::SidebarTrigger.new(controls: "main-sidebar"))
    assert_includes html, %(aria-controls="main-sidebar")
  end

  def test_sidebar_rail_renders_aria_expanded_and_controls
    html = render(PhlexKit::SidebarRail.new(expanded: false, controls: "main-sidebar"))
    assert_includes html, %(aria-expanded="false")
    assert_includes html, %(aria-controls="main-sidebar")
  end

  def test_sidebar_rail_defaults_to_expanded
    html = render(PhlexKit::SidebarRail.new)
    assert_includes html, %(aria-expanded="true")
  end

  # --- Finding 11: active link gets aria-current="page" ---------------------

  def test_sidebar_menu_button_active_link_gets_aria_current_page
    html = render(PhlexKit::SidebarMenuButton.new(as: :a, href: "/dash", active: true) { "Dashboard" })
    assert_includes html, %(aria-current="page")
  end

  def test_sidebar_menu_button_inactive_link_omits_aria_current
    html = render(PhlexKit::SidebarMenuButton.new(as: :a, href: "/dash") { "Dashboard" })
    refute_includes html, "aria-current"
  end

  def test_sidebar_menu_button_active_button_omits_aria_current
    html = render(PhlexKit::SidebarMenuButton.new(active: true) { "Dashboard" })
    refute_includes html, "aria-current"
  end

  # --- Finding 12a: tooltip provides the accessible name --------------------

  def test_sidebar_menu_button_tooltip_wires_aria_label
    html = render(PhlexKit::SidebarMenuButton.new(tooltip: "Dashboard") { "Dashboard" })
    assert_includes html, %(aria-label="Dashboard")
    assert_includes html, %(data-tooltip="Dashboard")
  end

  def test_sidebar_menu_button_without_tooltip_omits_aria_label
    html = render(PhlexKit::SidebarMenuButton.new { "Dashboard" })
    refute_includes html, "aria-label"
  end

  # --- Finding 12b: bare block text is wrapped in a span --------------------

  def test_sidebar_menu_button_wraps_bare_text_in_span
    html = render(PhlexKit::SidebarMenuButton.new { "Dashboard" })
    assert_includes html, "<span>Dashboard</span>"
  end

  def test_sidebar_menu_button_leaves_markup_blocks_alone
    component = Class.new(PhlexKit::BaseComponent) do
      def view_template
        render PhlexKit::SidebarMenuButton.new do
          span(class: "label") { "Reviews" }
        end
      end
    end
    html = render(component.new)
    assert_includes html, %(<span class="label">Reviews</span>)
    refute_includes html, %(<span><span class="label">)
  end
end
