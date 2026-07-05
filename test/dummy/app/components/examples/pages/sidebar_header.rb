# frozen_string_literal: true

module Examples
  module Pages
    # 01 sidebar-header — Harbor's Orders screen. The kit's own sidebar shell
    # (SidebarWrapper/Sidebar/SidebarInset) plays grid-layout's shell-sidebar.
    class SidebarHeader < BasePage
      TABS = [ [ "all", "All", 1204 ], [ "unfulfilled", "Unfulfilled", 41 ], [ "unpaid", "Unpaid", 12 ], [ "archived", "Archived", 86 ] ].freeze

      private

      def page_title = "Orders"

      def body_content
        render PhlexKit::SidebarWrapper.new(collapsible: :offcanvas, class: "adm-shell") do
          harbor_sidebar(active: "sidebar-header")
          render PhlexKit::SidebarInset.new do
            header(class: "adm-inset-header") do
              render PhlexKit::SidebarTrigger.new
              render PhlexKit::Separator.new(orientation: :vertical, class: "adm-header-sep")
              render PhlexKit::Breadcrumb.new do
                render PhlexKit::BreadcrumbList.new do
                  render PhlexKit::BreadcrumbItem.new do
                    render PhlexKit::BreadcrumbLink.new(href: "/examples/dashboard-cards") { "Harbor" }
                  end
                  render PhlexKit::BreadcrumbSeparator.new
                  render PhlexKit::BreadcrumbItem.new do
                    render PhlexKit::BreadcrumbPage.new { "Orders" }
                  end
                end
              end
              div(class: "adm-topbar-spacer")
              render PhlexKit::InputGroup.new(class: "adm-header-search") do
                render PhlexKit::InputGroupAddon.new { icon(:search, size: 14) }
                render PhlexKit::Input.new(placeholder: "Search orders…", aria: { label: "Search orders" })
              end
              user_menu
            end
            main(class: "adm-main") do
              div(class: "adm-page-head") do
                div do
                  h1(class: "adm-page-title") { "Orders" }
                  p(class: "adm-page-sub") { "1,204 orders · updated 2 minutes ago" }
                end
                div(class: "adm-head-actions") do
                  render PhlexKit::Button.new(variant: :outline, size: :sm) do
                    icon(:download, size: 14)
                    plain "Export"
                  end
                  render PhlexKit::Button.new(size: :sm) do
                    icon(:plus, size: 14)
                    plain "New order"
                  end
                end
              end
              render PhlexKit::Tabs.new(default: "all") do
                render PhlexKit::TabsList.new(variant: :line) do
                  TABS.each do |value, label, count|
                    render PhlexKit::TabsTrigger.new(value: value) do
                      plain label
                      render PhlexKit::Badge.new(variant: :secondary, size: :sm) { count.to_s }
                    end
                  end
                end
                render PhlexKit::TabsContent.new(value: "all") { orders_table(ORDERS) }
                render PhlexKit::TabsContent.new(value: "unfulfilled") { orders_table(ORDERS.select { |o| o[2] == "Pending" }) }
                render PhlexKit::TabsContent.new(value: "unpaid") { orders_table(ORDERS.select { |o| o[2] == "Pending" }) }
                render PhlexKit::TabsContent.new(value: "archived") { orders_table(ORDERS.select { |o| o[2] == "Refunded" }) }
              end
              render PhlexKit::Pagination.new do
                render PhlexKit::PaginationContent.new do
                  render PhlexKit::PaginationPrevious.new(href: "#")
                  render PhlexKit::PaginationLink.new(href: "#", active: true) { "1" }
                  render PhlexKit::PaginationLink.new(href: "#") { "2" }
                  render PhlexKit::PaginationLink.new(href: "#") { "3" }
                  render PhlexKit::PaginationEllipsis.new
                  render PhlexKit::PaginationLink.new(href: "#") { "121" }
                  render PhlexKit::PaginationNext.new(href: "#")
                end
              end
            end
            harbor_footer "Showing 10 of 1,204 orders · Harbor v2.4"
          end
        end
      end

      def user_menu
        render PhlexKit::DropdownMenu.new do
          render PhlexKit::DropdownMenuTrigger.new do
            render PhlexKit::Button.new(variant: :ghost, icon: true, aria: { label: "Account" }) do
              render PhlexKit::Avatar.new(size: :sm) { render PhlexKit::AvatarFallback.new { "MK" } }
            end
          end
          render PhlexKit::DropdownMenuContent.new(class: "adm-user-menu") do
            render PhlexKit::DropdownMenuLabel.new { "Mae Keller" }
            render PhlexKit::DropdownMenuSeparator.new
            render PhlexKit::DropdownMenuItem.new(href: "#") do
              icon(:user, size: nil)
              plain "Profile"
            end
            render PhlexKit::DropdownMenuItem.new(href: "#") do
              icon(:credit_card, size: nil)
              plain "Billing"
            end
            render PhlexKit::DropdownMenuSeparator.new
            render PhlexKit::DropdownMenuItem.new(href: "#") do
              icon(:log_out, size: nil)
              plain "Sign out"
            end
          end
        end
      end

      def orders_table(rows)
        render PhlexKit::Table.new(class: "adm-orders-table") do
          render PhlexKit::TableHeader.new do
            render PhlexKit::TableRow.new do
              render PhlexKit::TableHead.new { "Order" }
              render PhlexKit::TableHead.new { "Customer" }
              render PhlexKit::TableHead.new { "Status" }
              render PhlexKit::TableHead.new(class: "adm-num") { "Items" }
              render PhlexKit::TableHead.new(class: "adm-num") { "Total" }
              render PhlexKit::TableHead.new(class: "adm-num") { "Date" }
            end
          end
          render PhlexKit::TableBody.new do
            rows.each do |id, customer, status, items, total, date|
              render PhlexKit::TableRow.new do
                render PhlexKit::TableCell.new(class: "adm-mono") { id }
                render PhlexKit::TableCell.new { customer }
                render PhlexKit::TableCell.new { status_badge(status) }
                render PhlexKit::TableCell.new(class: "adm-num") { items.to_s }
                render PhlexKit::TableCell.new(class: "adm-num") { total }
                render PhlexKit::TableCell.new(class: "adm-num adm-muted") { date }
              end
            end
          end
        end
      end

      def local_css
        <<~CSS
          .adm-inset-header { display: flex; align-items: center; gap: .75rem; padding: .5rem 1.25rem;
                              border-bottom: 1px solid var(--pk-border); position: sticky; top: 0;
                              background: var(--pk-bg); z-index: 40; }
          .adm-header-sep { height: 1rem; }
          .adm-header-search { width: 240px; }
          .adm-user-menu { right: 0; left: auto; min-width: 12rem; }
          .adm-orders-table { margin-top: .75rem; }
          .pk-tabs-trigger .pk-badge { margin-left: .375rem; }
        CSS
      end
    end
  end
end
