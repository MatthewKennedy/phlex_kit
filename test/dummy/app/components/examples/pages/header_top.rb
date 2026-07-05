# frozen_string_literal: true

module Examples
  module Pages
    # 02 header-top — Harbor's Reports screen: the sidebar-less variant, a top
    # navigation bar over summary cards and a full-width chart (l-page frame).
    class HeaderTop < BasePage
      CHANNELS = [
        [ "Online store", "$31,204", "812 orders", 64 ],
        [ "Wholesale", "$11,890", "96 orders", 25 ],
        [ "Point of sale", "$5,136", "296 orders", 11 ]
      ].freeze

      private

      def page_title = "Reports"

      def body_content
        div(class: "adm-page") do
          harbor_topbar do
            render PhlexKit::NavigationMenu.new(class: "adm-topnav") do
              render PhlexKit::NavigationMenuList.new do
                render PhlexKit::NavigationMenuItem.new do
                  render PhlexKit::NavigationMenuLink.new(href: "/examples/dashboard-cards") { "Overview" }
                end
                render PhlexKit::NavigationMenuItem.new do
                  render PhlexKit::NavigationMenuLink.new(href: "/examples/header-top", class: "adm-topnav-active") { "Reports" }
                end
                render PhlexKit::NavigationMenuItem.new do
                  render PhlexKit::NavigationMenuTrigger.new { "Channels" }
                  render PhlexKit::NavigationMenuContent.new do
                    render PhlexKit::NavigationMenuLink.new(href: "#") { "Online store" }
                    render PhlexKit::NavigationMenuLink.new(href: "#") { "Wholesale" }
                    render PhlexKit::NavigationMenuLink.new(href: "#") { "Point of sale" }
                  end
                end
                render PhlexKit::NavigationMenuItem.new do
                  render PhlexKit::NavigationMenuLink.new(href: "/examples/holy-grail") { "Customers" }
                end
              end
            end
            div(class: "adm-topbar-spacer")
          end

          main(class: "adm-main adm-reports") do
            div(class: "adm-page-head") do
              div do
                h1(class: "adm-page-title") { "Reports" }
                p(class: "adm-page-sub") { "Revenue by channel, June 2026" }
              end
              div(class: "adm-head-actions") do
                render PhlexKit::Button.new(variant: :outline, size: :sm) do
                  icon(:calendar, size: 14)
                  plain "June 2026"
                end
                render PhlexKit::Button.new(variant: :outline, size: :sm) do
                  icon(:download, size: 14)
                  plain "Export CSV"
                end
              end
            end

            div(class: "adm-summary-row") do
              summary_card("Gross revenue", "$48,230") do
                render PhlexKit::Badge.new(variant: :success, size: :sm) { "+12.4% vs May" }
              end
              summary_card("Refund rate", "1.8%") do
                render PhlexKit::Progress.new(value: 18, class: "adm-summary-progress")
              end
              summary_card("Conversion", "3.4%") do
                render PhlexKit::Badge.new(variant: :secondary, size: :sm) { "+0.2 pts" }
              end
            end

            render PhlexKit::Card.new do
              render PhlexKit::CardHeader.new do
                render PhlexKit::CardTitle.new { "Monthly revenue" }
                render PhlexKit::CardDescription.new { "Gross, all channels" }
              end
              render PhlexKit::CardContent.new(class: "adm-chart") do
                render PhlexKit::Chart.new(options: {
                  type: "bar",
                  data: {
                    labels: %w[Jan Feb Mar Apr May Jun],
                    datasets: [ { label: "Revenue", data: [ 31_400, 28_900, 35_200, 38_100, 42_900, 48_230 ],
                                  borderWidth: 0, borderRadius: 4 } ]
                  },
                  options: {
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: { x: { grid: { display: false } }, y: { border: { display: false }, ticks: { maxTicksLimit: 5 } } }
                  }
                })
              end
            end

            render PhlexKit::Card.new do
              render PhlexKit::CardHeader.new do
                render PhlexKit::CardTitle.new { "By channel" }
              end
              render PhlexKit::CardContent.new do
                render PhlexKit::Table.new do
                  render PhlexKit::TableHeader.new do
                    render PhlexKit::TableRow.new do
                      render PhlexKit::TableHead.new { "Channel" }
                      render PhlexKit::TableHead.new(class: "adm-num") { "Revenue" }
                      render PhlexKit::TableHead.new(class: "adm-num") { "Orders" }
                      render PhlexKit::TableHead.new(class: "adm-num") { "Share" }
                    end
                  end
                  render PhlexKit::TableBody.new do
                    CHANNELS.each do |name, revenue, orders, share|
                      render PhlexKit::TableRow.new do
                        render PhlexKit::TableCell.new { name }
                        render PhlexKit::TableCell.new(class: "adm-num") { revenue }
                        render PhlexKit::TableCell.new(class: "adm-num adm-muted") { orders }
                        render PhlexKit::TableCell.new(class: "adm-num") { "#{share}%" }
                      end
                    end
                  end
                end
              end
            end
          end

          harbor_footer "Figures are net of tax · Harbor v2.4"
        end
      end

      def summary_card(label, value, &block)
        render PhlexKit::Card.new do
          render PhlexKit::CardHeader.new do
            render PhlexKit::CardDescription.new { label }
            render PhlexKit::CardTitle.new(class: "adm-kpi-value") { value }
            render PhlexKit::CardAction.new(&block)
          end
        end
      end

      def local_css
        <<~CSS
          .adm-reports { width: min(72rem, 100%); margin: 0 auto; }
          .adm-topnav .pk-navigation-menu-content { min-width: 12rem; }
          .adm-topnav-active { font-weight: 600; }
          .adm-summary-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; }
          .adm-summary-progress { width: 90px; }
          .adm-kpi-value { font-size: 1.5rem; letter-spacing: -.02em; font-variant-numeric: tabular-nums; }
          .adm-chart { height: 260px; }
        CSS
      end
    end
  end
end
