# frozen_string_literal: true

module Docs
  module Examples
    module Sidebar
      class Default < Phlex::HTML
        def view_template
          div(class: "w-lg", style: "height:300px;overflow:hidden;border:1px solid var(--pk-border);border-radius:var(--pk-radius)") do
            render PhlexKit::SidebarWrapper.new do
              render PhlexKit::Sidebar.new(style: "height:100%") do
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
                render PhlexKit::SidebarFooter.new { "v0.2.1" }
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
