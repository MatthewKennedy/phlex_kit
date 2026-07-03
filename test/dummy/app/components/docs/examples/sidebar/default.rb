# frozen_string_literal: true

module Docs
  module Examples
    module Sidebar
      class Default < Phlex::HTML
        def view_template
          div(class: "w-lg", style: "height:480px;overflow:hidden;border:1px solid var(--pk-border);border-radius:var(--pk-radius)") do
            render PhlexKit::SidebarWrapper.new do
              render PhlexKit::Sidebar.new(style: "height:100%") do
                render PhlexKit::SidebarHeader.new do
                  plain "Acme Inc"
                  render PhlexKit::SidebarInput.new(placeholder: "Search…")
                end
                render PhlexKit::SidebarContent.new do
                  render PhlexKit::SidebarGroup.new do
                    render PhlexKit::SidebarGroupLabel.new { "Application" }
                    render PhlexKit::SidebarGroupAction.new(aria_label: "Add") { "+" }
                    render PhlexKit::SidebarGroupContent.new do
                      render PhlexKit::SidebarMenu.new do
                        render PhlexKit::SidebarMenuItem.new do
                          render PhlexKit::SidebarMenuButton.new(active: true) { "Dashboard" }
                        end
                        render PhlexKit::SidebarMenuItem.new do
                          render PhlexKit::SidebarMenuButton.new { "Orders" }
                          render PhlexKit::SidebarMenuBadge.new { "24" }
                        end
                        render PhlexKit::SidebarMenuItem.new do
                          render PhlexKit::SidebarMenuButton.new { "Settings" }
                          render PhlexKit::SidebarMenuAction.new(aria_label: "More") { "⋯" }
                          render PhlexKit::SidebarMenuSub.new do
                            render PhlexKit::SidebarMenuSubItem.new do
                              render PhlexKit::SidebarMenuSubButton.new(href: "#", active: true) { "General" }
                            end
                            render PhlexKit::SidebarMenuSubItem.new do
                              render PhlexKit::SidebarMenuSubButton.new(href: "#") { "Billing" }
                            end
                          end
                        end
                      end
                    end
                  end
                  render PhlexKit::SidebarSeparator.new
                  render PhlexKit::SidebarGroup.new do
                    render PhlexKit::SidebarGroupLabel.new { "Loading" }
                    render PhlexKit::SidebarGroupContent.new do
                      render PhlexKit::SidebarMenu.new do
                        render PhlexKit::SidebarMenuItem.new do
                          render PhlexKit::SidebarMenuSkeleton.new(show_icon: true)
                        end
                        render PhlexKit::SidebarMenuItem.new do
                          render PhlexKit::SidebarMenuSkeleton.new
                        end
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
