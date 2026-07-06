# frozen_string_literal: true

module Examples
  module Pages
    # 04 dashboard-cards — Harbor's Dashboard: an auto-fit KPI row over a
    # 3-column bento grid (span-2 chart, row-span-2 feed, span-2 table).
    class DashboardCards < BasePage
      KPIS = [
        [ "Revenue", "$48,230", "+12.4%", :success ],
        [ "Orders", "1,204", "+8.1%", :success ],
        [ "Average order", "$40.05", "+3.9%", :success ],
        [ "Refund rate", "1.8%", "-0.4%", :secondary ]
      ].freeze

      ACTIVITY = [
        [ "AT", "Ada Thornton placed #HB-1042", "3 items · $182.00", "2m" ],
        [ "HB", "Refund issued on #HB-1038", "Lena Fischer · $58.00", "26m" ],
        [ "HB", "Low stock: Anchor Hoodie (M)", "4 left · reorder point 10", "1h" ],
        [ "PN", "Priya Nair placed #HB-1040", "5 items · $310.50", "2h" ],
        [ "HB", "Payout sent", "$12,410.22 to •••6021", "5h" ],
        [ "RP", "Ravi Patel placed #HB-1035", "6 items · $412.20", "8h" ],
        [ "HB", "Inventory sync finished", "312 products from warehouse", "9h" ]
      ].freeze

      private

      def page_title = "Dashboard"

      def body_content
        render PhlexKit::SidebarWrapper.new(collapsible: :offcanvas, class: "adm-shell") do
          harbor_sidebar(active: "dashboard-cards")
          render PhlexKit::SidebarInset.new do
            harbor_inset_header("Dashboard")
            main(class: "adm-main") do
              div(class: "adm-page-head") do
                div do
                  h1(class: "adm-page-title") { "Good morning, Mae" }
                  p(class: "adm-page-sub") { "Here's the store for the last 30 days." }
                end
                div(class: "adm-head-actions") do
                  render PhlexKit::ButtonGroup.new do
                    render PhlexKit::Button.new(variant: :outline, size: :sm) { "30 days" }
                    render PhlexKit::Button.new(variant: :outline, size: :sm) { "90 days" }
                    render PhlexKit::Button.new(variant: :outline, size: :sm) { "Year" }
                  end
                  render PhlexKit::Button.new(size: :sm) do
                    icon(:download, size: 14)
                    plain "Report"
                  end
                end
              end

              div(class: "adm-kpis") do
                KPIS.each { |kpi| kpi_card(*kpi) }
              end

              div(class: "adm-bento") do
                revenue_card
                activity_card
                top_product_card
                alerts_card
                recent_orders_card
              end
            end
            harbor_footer "Data refreshed 2 minutes ago · Harbor v2.4"
          end
        end
      end

      def kpi_card(label, value, delta, variant)
        render PhlexKit::Card.new(class: "adm-kpi") do
          render PhlexKit::CardHeader.new do
            render PhlexKit::CardDescription.new { label }
            render PhlexKit::CardTitle.new(class: "adm-kpi-value") { value }
            render PhlexKit::CardAction.new do
              render PhlexKit::Badge.new(variant: variant, size: :sm) { delta }
            end
          end
        end
      end

      def revenue_card
        render PhlexKit::Card.new(class: "adm-span-2") do
          render PhlexKit::CardHeader.new do
            render PhlexKit::CardTitle.new { "Revenue" }
            render PhlexKit::CardDescription.new { "Daily gross revenue, June" }
            render PhlexKit::CardAction.new do
              render PhlexKit::Badge.new(variant: :outline, size: :sm) { "$48,230" }
            end
          end
          render PhlexKit::CardContent.new(class: "adm-chart") do
            render PhlexKit::Chart.new(options: {
              type: "line",
              data: {
                labels: [ "Jun 1", "Jun 5", "Jun 9", "Jun 13", "Jun 17", "Jun 21", "Jun 25", "Jun 29" ],
                datasets: [
                  { label: "Revenue", data: [ 1180, 1420, 1310, 1680, 1540, 1890, 1760, 2140 ],
                    fill: true, tension: 0.4, pointRadius: 0, borderWidth: 2 }
                ]
              },
              options: {
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { x: { grid: { display: false } }, y: { border: { display: false }, ticks: { maxTicksLimit: 4 } } }
              }
            })
          end
        end
      end

      def activity_card
        render PhlexKit::Card.new(class: "adm-rspan-2 adm-activity") do
          render PhlexKit::CardHeader.new do
            render PhlexKit::CardTitle.new { "Activity" }
            render PhlexKit::CardDescription.new { "Across the store, live" }
          end
          render PhlexKit::CardContent.new do
            render PhlexKit::ItemGroup.new do
              ACTIVITY.each_with_index do |(initials, title, detail, at), i|
                render PhlexKit::ItemSeparator.new if i.positive?
                render PhlexKit::Item.new(size: :sm) do
                  render PhlexKit::ItemMedia.new do
                    render PhlexKit::Avatar.new(size: :sm) { render PhlexKit::AvatarFallback.new { initials } }
                  end
                  render PhlexKit::ItemContent.new do
                    render PhlexKit::ItemTitle.new { title }
                    render PhlexKit::ItemDescription.new { detail }
                  end
                  render PhlexKit::ItemActions.new do
                    span(class: "adm-muted adm-when") { at }
                  end
                end
              end
            end
          end
        end
      end

      def top_product_card
        render PhlexKit::Card.new do
          render PhlexKit::CardHeader.new do
            render PhlexKit::CardTitle.new { "Top product" }
            render PhlexKit::CardDescription.new { "By revenue this month" }
          end
          render PhlexKit::CardContent.new(class: "adm-stack") do
            render PhlexKit::Item.new(size: :sm) do
              render PhlexKit::ItemMedia.new(variant: :icon) { icon(:tag) }
              render PhlexKit::ItemContent.new do
                render PhlexKit::ItemTitle.new { "Anchor Hoodie" }
                render PhlexKit::ItemDescription.new { "412 sold · $16,480" }
              end
            end
            div(class: "adm-between") do
              span(class: "adm-muted") { "of monthly goal" }
              span { "68%" }
            end
            render PhlexKit::Progress.new(value: 68)
          end
        end
      end

      def alerts_card
        render PhlexKit::Card.new do
          render PhlexKit::CardHeader.new do
            render PhlexKit::CardTitle.new { "Inventory alerts" }
            render PhlexKit::CardDescription.new { "Below reorder point" }
          end
          render PhlexKit::CardContent.new(class: "adm-stack") do
            [ [ "Anchor Hoodie (M)", 4 ], [ "Tide Bottle 750ml", 7 ], [ "Quay Cap", 9 ] ].each do |name, left|
              div(class: "adm-between") do
                span { name }
                render PhlexKit::Badge.new(variant: :warning, size: :sm) { "#{left} left" }
              end
            end
          end
          render PhlexKit::CardFooter.new do
            render PhlexKit::Button.new(
              variant: :outline, size: :sm,
              onclick: safe("PhlexKit.toast.success('Reorder placed', { description: '3 products queued with your supplier.' })")
            ) { "Reorder stock" }
          end
        end
      end

      def recent_orders_card
        render PhlexKit::Card.new(class: "adm-span-2") do
          render PhlexKit::CardHeader.new do
            render PhlexKit::CardTitle.new { "Recent orders" }
            render PhlexKit::CardAction.new do
              render PhlexKit::Button.new(variant: :ghost, size: :sm, href: "/examples/sidebar-header") do
                plain "View all"
                icon(:arrow_right, size: 14)
              end
            end
          end
          render PhlexKit::CardContent.new do
            render PhlexKit::Table.new do
              render PhlexKit::TableBody.new do
                ORDERS.first(5).each do |id, customer, status, _items, total, date|
                  render PhlexKit::TableRow.new do
                    render PhlexKit::TableCell.new(class: "adm-mono") { id }
                    render PhlexKit::TableCell.new { customer }
                    render PhlexKit::TableCell.new { status_badge(status) }
                    render PhlexKit::TableCell.new(class: "adm-num") { total }
                    render PhlexKit::TableCell.new(class: "adm-num adm-muted") { date }
                  end
                end
              end
            end
          end
        end
      end

      def local_css
        <<~CSS
          .adm-kpi .pk-card-header { padding-bottom: 1rem; }
          .adm-kpi-value { font-size: 1.5rem; letter-spacing: -.02em; font-variant-numeric: tabular-nums; }
          .adm-chart { height: 220px; }
          .adm-chart canvas { max-height: 200px; }
          .adm-activity .pk-item { padding-inline: 0; }
          .adm-when { font-size: .75rem; flex: none; }
        CSS
      end
    end
  end
end
