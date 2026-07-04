# frozen_string_literal: true

module Docs
  module Examples
    module Sidebar
      class Offcanvas < Phlex::HTML
        def view_template
          div(class: "w-lg", style: "height:320px;overflow:hidden;border:1px solid var(--pk-border);border-radius:var(--pk-radius)") do
            render PhlexKit::SidebarWrapper.new(collapsible: :offcanvas) do
              render PhlexKit::Sidebar.new(style: "height:100%") do
                render PhlexKit::SidebarHeader.new { "Acme Inc" }
                render PhlexKit::SidebarContent.new do
                  render PhlexKit::SidebarMenu.new do
                    render PhlexKit::SidebarMenuItem.new do
                      render PhlexKit::SidebarMenuButton.new(active: true) { "Dashboard" }
                    end
                    render PhlexKit::SidebarMenuItem.new do
                      render PhlexKit::SidebarMenuButton.new { "Orders" }
                    end
                  end
                end
                render PhlexKit::SidebarFooter.new { "signed in" }
              end
              render PhlexKit::SidebarInset.new do
                div(style: "padding:1rem;display:flex;align-items:center;gap:.5rem") do
                  render PhlexKit::SidebarTrigger.new
                  plain "Toggle the rail. Below 768px it opens as an overlay drawer behind a scrim."
                end
              end
            end
          end
        end
      end
    end
  end
end
