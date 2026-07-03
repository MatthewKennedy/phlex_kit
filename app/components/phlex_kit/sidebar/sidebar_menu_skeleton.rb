module PhlexKit
  # Loading placeholder for a menu item, ported from shadcn/ui's
  # SidebarMenuSkeleton: an optional icon shimmer plus a text shimmer whose
  # width randomises 50–90% per render (their --skeleton-width trick).
  # `show_icon:` mirrors shadcn's showIcon. See sidebar.rb.
  class SidebarMenuSkeleton < BaseComponent
    def initialize(show_icon: false, **attrs)
      @show_icon = show_icon
      @attrs = attrs
    end

    def view_template
      div(**mix({ class: "pk-sidebar-menu-skeleton" }, @attrs)) do
        render Skeleton.new(class: "icon") if @show_icon
        render Skeleton.new(class: "text", style: "--pk-skeleton-width: #{rand(50..90)}%;")
      end
    end
  end
end
