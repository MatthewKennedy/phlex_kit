# frozen_string_literal: true

module Docs
  module Examples
    module Sidebar
      class IconRail < Phlex::HTML
        ITEMS = [
          [ :home, "Dashboard", true ],
          [ :shopping_cart, "Orders", false ],
          [ :settings, "Settings", false ]
        ].freeze

        def view_template
          div(class: "w-lg", style: "height: 320px; overflow: hidden; border: 1px solid var(--pk-border); border-radius: var(--pk-radius);") do
            # collapsible: :icon shrinks the rail to a 3rem icon strip: labels
            # hide, buttons become squares, tooltip: labels them on hover.
            # ⌘B toggles too, and the state persists in the pk_sidebar_state
            # cookie (pass default_collapsed: from your layout to avoid flash).
            render PhlexKit::SidebarWrapper.new(collapsible: :icon) do
              render PhlexKit::Sidebar.new(style: "height: 100%") do
                render PhlexKit::SidebarHeader.new { "Acme Inc" }
                render PhlexKit::SidebarContent.new do
                  render PhlexKit::SidebarGroup.new do
                    render PhlexKit::SidebarGroupLabel.new { "Platform" }
                    render PhlexKit::SidebarGroupContent.new do
                      render PhlexKit::SidebarMenu.new do
                        ITEMS.each do |icon, label, active|
                          render PhlexKit::SidebarMenuItem.new do
                            render PhlexKit::SidebarMenuButton.new(active: active, tooltip: label) do
                              render PhlexKit::Icon.new(icon, size: nil)
                              span { label }
                            end
                          end
                        end
                      end
                    end
                  end
                end
                render PhlexKit::SidebarFooter.new { "signed in" }
                # The invisible edge strip also toggles the collapse.
                render PhlexKit::SidebarRail.new
              end
              render PhlexKit::SidebarInset.new do
                div(style: "padding: 1rem; display: flex; align-items: center; gap: .5rem;") do
                  render PhlexKit::SidebarTrigger.new
                  plain "Collapse to an icon rail — hover the icons for labels, or grab the edge."
                end
              end
            end
          end
        end
      end
    end
  end
end
