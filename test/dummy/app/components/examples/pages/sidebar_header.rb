# frozen_string_literal: true

module Examples
  module Pages
    # 01 sidebar-header — Harbor's Orders screen. The kit's own sidebar shell
    # (SidebarWrapper/Sidebar/SidebarInset) plays grid-layout's shell-sidebar;
    # the table is the full DataTable suite (search, selection, sort, column
    # toggle, bulk actions, pagination).
    class SidebarHeader < BasePage
      # value, label, filter for the shared order book
      TABS = [
        [ "all", "All", ->(_o) { true } ],
        [ "unfulfilled", "Unfulfilled", ->(o) { o[2] == "Paid" } ],
        [ "unpaid", "Unpaid", ->(o) { o[2] == "Pending" } ],
        [ "archived", "Archived", ->(o) { o[2] == "Refunded" } ]
      ].freeze

      private

      def page_title = "Orders"

      def body_content
        render PhlexKit::SidebarWrapper.new(collapsible: :offcanvas, class: "adm-shell") do
          harbor_sidebar(active: "sidebar-header")
          render PhlexKit::SidebarInset.new do
            harbor_inset_header("Orders") { user_menu }
            main(class: "adm-main") do
              div(class: "adm-page-head") do
                div do
                  h1(class: "adm-page-title") { "Orders" }
                  p(class: "adm-page-sub") { "1,204 orders · updated 2 minutes ago" }
                end
                div(class: "adm-head-actions") do
                  render PhlexKit::Button.new(
                    variant: :outline, size: :sm,
                    onclick: safe("PhlexKit.toast.info('Export started', { description: 'orders.csv will land in your email.' })")
                  ) do
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
                  TABS.each do |value, label, filter|
                    count = value == "all" ? 1204 : ORDERS.count(&filter)
                    render PhlexKit::TabsTrigger.new(value: value) do
                      plain label
                      render PhlexKit::Badge.new(variant: :secondary, size: :sm) { count.to_s }
                    end
                  end
                end
                TABS.each do |value, _label, filter|
                  render PhlexKit::TabsContent.new(value: value) do
                    orders_data_table(value, ORDERS.select(&filter))
                  end
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

      # The kit's server-driven DataTable — sorting/search/pagination are
      # links and params a real controller would answer; here they just
      # reload the page, which is enough to demo the grammar.
      def orders_data_table(tab, rows)
        render PhlexKit::DataTable.new(id: "orders-#{tab}", class: "adm-orders-table") do
          render PhlexKit::DataTableToolbar.new do
            render PhlexKit::DataTableSearch.new(path: "/examples/sidebar-header", frame_id: "orders-#{tab}", placeholder: "Filter orders…")
            render PhlexKit::DataTableBulkActions.new do
              render PhlexKit::Button.new(
                variant: :outline, size: :sm,
                onclick: safe("PhlexKit.toast.success('Orders fulfilled', { description: 'Selected orders were marked fulfilled.' })")
              ) { "Fulfill selected" }
            end
            render PhlexKit::DataTableColumnToggle.new(columns: [
              { key: "status", label: "Status" }, { key: "items", label: "Items" }, { key: "date", label: "Date" }
            ])
          end
          render PhlexKit::Table.new do
            render PhlexKit::TableHeader.new do
              render PhlexKit::TableRow.new do
                render PhlexKit::TableHead.new { render PhlexKit::DataTableSelectAllCheckbox.new }
                render PhlexKit::DataTableSortHead.new(column_key: :id, label: "Order", path: "/examples/sidebar-header")
                render PhlexKit::DataTableSortHead.new(column_key: :customer, label: "Customer", path: "/examples/sidebar-header")
                render PhlexKit::TableHead.new(data: { column: "status" }) { "Status" }
                render PhlexKit::TableHead.new(data: { column: "items" }, class: "adm-num") { "Items" }
                render PhlexKit::TableHead.new(class: "adm-num") { "Total" }
                render PhlexKit::TableHead.new(data: { column: "date" }, class: "adm-num") { "Date" }
                render PhlexKit::TableHead.new(style: "width: 2rem") { span(class: "pk-sr-only") { "Actions" } }
              end
            end
            render PhlexKit::TableBody.new do
              rows.each do |id, customer, status, items, total, date|
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableCell.new { render PhlexKit::DataTableRowCheckbox.new(value: id) }
                  render PhlexKit::TableCell.new(class: "adm-mono") { id }
                  render PhlexKit::TableCell.new { customer }
                  render PhlexKit::TableCell.new(data: { column: "status" }) { status_badge(status) }
                  render PhlexKit::TableCell.new(data: { column: "items" }, class: "adm-num") { items.to_s }
                  render PhlexKit::TableCell.new(class: "adm-num") { total }
                  render PhlexKit::TableCell.new(data: { column: "date" }, class: "adm-num adm-muted") { date }
                  render PhlexKit::TableCell.new { row_menu(id) }
                end
              end
            end
          end
          render PhlexKit::DataTablePaginationBar.new do
            render PhlexKit::DataTableSelectionSummary.new(total_on_page: rows.size)
            render PhlexKit::DataTablePagination.new(page: 1, per_page: 10, total_count: 1204, path: "/examples/sidebar-header")
          end
        end
      end

      def row_menu(id)
        render PhlexKit::DropdownMenu.new do
          render PhlexKit::DropdownMenuTrigger.new do
            render PhlexKit::Button.new(variant: :ghost, icon: true, aria: { label: "Open menu for #{id}" }) do
              icon(:ellipsis, size: nil)
            end
          end
          render PhlexKit::DropdownMenuContent.new(class: "adm-user-menu") do
            render PhlexKit::DropdownMenuItem.new(href: "/examples/master-detail") { "Open in inbox" }
            render PhlexKit::DropdownMenuItem.new(href: "#") { "Copy order ID" }
            render PhlexKit::DropdownMenuSeparator.new
            render PhlexKit::DropdownMenuItem.new(href: "#", variant: :destructive) { "Cancel order" }
          end
        end
      end

      def local_css
        <<~CSS
          .adm-user-menu { right: 0; left: auto; min-width: 12rem; }
          .adm-orders-table { margin-top: .75rem; }
          .pk-tabs-trigger .pk-badge { margin-left: .375rem; }
        CSS
      end
    end
  end
end
