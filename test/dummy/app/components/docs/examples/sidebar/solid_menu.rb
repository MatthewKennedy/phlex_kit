# frozen_string_literal: true

module Docs
  module Examples
    module Sidebar
      # The create page's "Solid" menu mode: active items fill with the
      # primary/brand role (--pk-sidebar-primary) instead of the accent tint.
      class SolidMenu < Phlex::HTML
        def view_template
          div(class: "w-lg", style: "height:260px;overflow:hidden;border:1px solid var(--pk-border);border-radius:var(--pk-radius)") do
            render PhlexKit::SidebarWrapper.new do
              render PhlexKit::Sidebar.new(menu: :solid, style: "height:100%") do
                render PhlexKit::SidebarHeader.new { "Acme Inc" }
                render PhlexKit::SidebarContent.new do
                  render PhlexKit::SidebarGroup.new do
                    render PhlexKit::SidebarMenu.new do
                      render PhlexKit::SidebarMenuItem.new do
                        render PhlexKit::SidebarMenuButton.new(active: true) { "Dashboard" }
                      end
                      render PhlexKit::SidebarMenuItem.new do
                        render PhlexKit::SidebarMenuButton.new { "Orders" }
                      end
                      render PhlexKit::SidebarMenuItem.new do
                        render PhlexKit::SidebarMenuButton.new { "Settings" }
                      end
                    end
                  end
                end
              end
              render PhlexKit::SidebarInset.new do
                div(class: "docs-panel") { "Main content" }
              end
            end
          end
        end
      end
    end
  end
end
