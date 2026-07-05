# frozen_string_literal: true

module Examples
  module Pages
    # 03 holy-grail — Harbor's Customer profile: full-width header, section
    # nav, content column and a widget aside (shell-holygrail; aside drops
    # below main ≤1024px, single column ≤768px).
    class HolyGrail < BasePage
      SECTIONS = [
        [ "Overview", true ], [ "Orders", false ], [ "Payments", false ], [ "Activity", false ]
      ].freeze

      STATS = [
        [ "Lifetime value", "$1,482" ], [ "Orders", "8" ], [ "Avg. order", "$185" ], [ "Customer since", "2024" ]
      ].freeze

      private

      def page_title = "Customer profile"

      def body_content
        div(class: "adm-holygrail") do
          harbor_topbar do
            render PhlexKit::Breadcrumb.new do
              render PhlexKit::BreadcrumbList.new do
                render PhlexKit::BreadcrumbItem.new do
                  render PhlexKit::BreadcrumbLink.new(href: "/examples/dashboard-cards") { "Harbor" }
                end
                render PhlexKit::BreadcrumbSeparator.new
                render PhlexKit::BreadcrumbItem.new do
                  render PhlexKit::BreadcrumbLink.new(href: "#") { "Customers" }
                end
                render PhlexKit::BreadcrumbSeparator.new
                render PhlexKit::BreadcrumbItem.new do
                  render PhlexKit::BreadcrumbPage.new { "Ada Thornton" }
                end
              end
            end
            div(class: "adm-topbar-spacer")
          end

          nav(class: "adm-hg-nav") do
            SECTIONS.each do |label, active|
              a(href: "#", class: [ "adm-nav-link", ("active" if active) ].compact.join(" ")) { label }
            end
          end

          main(class: "adm-hg-main adm-main") do
            div(class: "adm-customer-head") do
              render PhlexKit::Avatar.new(size: :lg) { render PhlexKit::AvatarFallback.new { "AT" } }
              div do
                div(class: "adm-row") do
                  h1(class: "adm-page-title") { "Ada Thornton" }
                  render PhlexKit::Badge.new(variant: :secondary, size: :sm) { "VIP" }
                  render PhlexKit::Badge.new(variant: :outline, size: :sm) { "Repeat buyer" }
                end
                p(class: "adm-page-sub") { "ada.thornton@example.com · Bristol, United Kingdom" }
              end
              div(class: "adm-head-actions") do
                render PhlexKit::Button.new(variant: :outline, size: :sm) do
                  icon(:mail, size: 14)
                  plain "Email"
                end
                render PhlexKit::Button.new(size: :sm) { "New order" }
              end
            end

            div(class: "adm-customer-stats") do
              STATS.each_with_index do |(label, value), i|
                render PhlexKit::Separator.new(orientation: :vertical, class: "adm-stat-sep") if i.positive?
                div(class: "adm-stat") do
                  span(class: "adm-muted") { label }
                  strong(class: "adm-stat-value") { value }
                end
              end
            end

            render PhlexKit::Card.new do
              render PhlexKit::CardHeader.new do
                render PhlexKit::CardTitle.new { "Recent orders" }
                render PhlexKit::CardAction.new do
                  render PhlexKit::Button.new(variant: :ghost, size: :sm, href: "/examples/master-detail") do
                    plain "Open inbox"
                    icon(:arrow_right, size: 14)
                  end
                end
              end
              render PhlexKit::CardContent.new do
                render PhlexKit::Table.new do
                  render PhlexKit::TableBody.new do
                    [ ORDERS[0], ORDERS[4], ORDERS[8] ].each do |id, _customer, status, items, total, date|
                      render PhlexKit::TableRow.new do
                        render PhlexKit::TableCell.new(class: "adm-mono") { id }
                        render PhlexKit::TableCell.new { status_badge(status) }
                        render PhlexKit::TableCell.new(class: "adm-num adm-muted") { "#{items} items" }
                        render PhlexKit::TableCell.new(class: "adm-num") { total }
                        render PhlexKit::TableCell.new(class: "adm-num adm-muted") { date }
                      end
                    end
                  end
                end
              end
            end
          end

          aside(class: "adm-hg-aside") do
            render PhlexKit::Card.new do
              render PhlexKit::CardHeader.new do
                render PhlexKit::CardTitle.new { "Lifetime value" }
                render PhlexKit::CardDescription.new { "Cumulative, by quarter" }
              end
              render PhlexKit::CardContent.new(class: "adm-aside-chart") do
                render PhlexKit::Chart.new(options: {
                  type: "line",
                  data: {
                    labels: %w[Q3 Q4 Q1 Q2],
                    datasets: [ { label: "LTV", data: [ 240, 610, 1010, 1482 ],
                                  fill: true, tension: 0.4, pointRadius: 0, borderWidth: 2 } ]
                  },
                  options: {
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: { x: { grid: { display: false } }, y: { display: false } }
                  }
                })
              end
            end

            render PhlexKit::Card.new do
              render PhlexKit::CardHeader.new do
                render PhlexKit::CardTitle.new { "Tags" }
              end
              render PhlexKit::CardContent.new(class: "adm-stack") do
                div(class: "adm-tag-row") do
                  render PhlexKit::Badge.new(variant: :secondary, size: :sm) { "wholesale-lead" }
                  render PhlexKit::Badge.new(variant: :secondary, size: :sm) { "newsletter" }
                  render PhlexKit::Badge.new(variant: :secondary, size: :sm) { "uk" }
                end
                render PhlexKit::InputGroup.new do
                  render PhlexKit::Input.new(placeholder: "Add tag…", aria: { label: "Add tag" })
                  render PhlexKit::InputGroupButton.new do
                    render PhlexKit::Button.new(variant: :ghost, size: :sm, icon: true, aria: { label: "Add" }) do
                      icon(:plus, size: 14)
                    end
                  end
                end
              end
            end

            render PhlexKit::Card.new do
              render PhlexKit::CardHeader.new do
                render PhlexKit::CardTitle.new { "Notes" }
              end
              render PhlexKit::CardContent.new(class: "adm-stack") do
                render PhlexKit::Textarea.new(rows: 3, placeholder: "Prefers morning deliveries…", aria: { label: "Customer note" })
                render PhlexKit::Button.new(variant: :outline, size: :sm) { "Save note" }
              end
            end
          end

          harbor_footer "Customer data is fictional · Harbor v2.4"
        end
      end

      def local_css
        <<~CSS
          .adm-customer-head { display: flex; align-items: center; gap: 1rem; flex-wrap: wrap; }
          .adm-customer-stats { display: flex; align-items: center; gap: 1.5rem;
                                border: 1px solid var(--pk-border); border-radius: var(--pk-radius);
                                padding: 1rem 1.25rem; flex-wrap: wrap; }
          .adm-stat { display: flex; flex-direction: column; gap: .125rem; font-size: .8125rem; }
          .adm-stat-sep { height: 2rem; }
          .adm-stat-value { font-size: 1.125rem; font-variant-numeric: tabular-nums; }
          .adm-aside-chart { height: 140px; }
          .adm-tag-row { display: flex; flex-wrap: wrap; gap: .375rem; }
        CSS
      end
    end
  end
end
