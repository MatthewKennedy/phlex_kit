# frozen_string_literal: true

module Examples
  module Pages
    # 05 master-detail — Harbor's Orders inbox: a scrolling list pane beside a
    # detail pane pinned header/body/footer (grid-layout's l-pin), inside the
    # kit's icon-rail sidebar shell.
    class MasterDetail < BasePage
      LINE_ITEMS = [
        [ "Anchor Hoodie (M)", 1, "$68.00" ],
        [ "Tide Bottle 750ml", 2, "$56.00" ],
        [ "Quay Cap", 1, "$29.00" ],
        [ "Shipping (tracked)", 1, "$29.00" ]
      ].freeze

      TIMELINE = [
        [ :circle_check, "Payment captured", "Jun 28, 09:14" ],
        [ :clock, "Awaiting fulfilment", "SLA: ships within 2 business days" ],
        [ :mail, "Confirmation sent", "ada.thornton@example.com" ]
      ].freeze

      private

      def page_title = "Orders inbox"

      def body_content
        render PhlexKit::SidebarWrapper.new(collapsible: :icon, class: "adm-shell") do
          harbor_sidebar(active: "master-detail")
          render PhlexKit::SidebarInset.new(class: "adm-inbox") do
            div(class: "adm-split") do
              list_pane
              detail_pane
            end
          end
        end
      end

      def list_pane
        div(class: "adm-list-pane") do
          div(class: "adm-between") do
            div(class: "adm-row") do
              render PhlexKit::SidebarTrigger.new
              h1(class: "adm-list-title") { "Inbox" }
            end
            render PhlexKit::Badge.new(variant: :secondary, size: :sm) { "41 open" }
          end
          div(class: "adm-row") do
            render PhlexKit::InputGroup.new(class: "adm-list-search") do
              render PhlexKit::InputGroupAddon.new { icon(:search, size: 14) }
              render PhlexKit::Input.new(placeholder: "Search inbox…", aria: { label: "Search inbox" })
            end
            filter_menu
          end
          div(class: "adm-list-scroll") do
            render PhlexKit::ItemGroup.new do
              ORDERS.first(8).each_with_index do |(id, customer, status, items, total, _date), i|
                render PhlexKit::Item.new(size: :sm, href: "#", class: [ "adm-inbox-row", ("active" if i.zero?) ].compact.join(" ")) do
                  render PhlexKit::ItemContent.new do
                    render PhlexKit::ItemTitle.new { customer }
                    render PhlexKit::ItemDescription.new { "#{id} · #{items} items · #{total}" }
                  end
                  render PhlexKit::ItemActions.new { status_badge(status) }
                end
              end
            end
          end
        end
      end

      def filter_menu
        render PhlexKit::DropdownMenu.new do
          render PhlexKit::DropdownMenuTrigger.new do
            render PhlexKit::Button.new(variant: :outline, icon: true, aria: { label: "Filter" }) do
              icon(:filter, size: 14)
            end
          end
          render PhlexKit::DropdownMenuContent.new do
            render PhlexKit::DropdownMenuLabel.new { "Show" }
            render PhlexKit::DropdownMenuItem.new(href: "#") { "All orders" }
            render PhlexKit::DropdownMenuItem.new(href: "#") { "Needs fulfilment" }
            render PhlexKit::DropdownMenuItem.new(href: "#") { "Awaiting payment" }
            render PhlexKit::DropdownMenuItem.new(href: "#") { "Refund requested" }
          end
        end
      end

      def detail_pane
        div(class: "adm-pin") do
          header(class: "adm-pin-header adm-between") do
            div do
              render PhlexKit::Breadcrumb.new do
                render PhlexKit::BreadcrumbList.new do
                  render PhlexKit::BreadcrumbItem.new do
                    render PhlexKit::BreadcrumbLink.new(href: "/examples/sidebar-header") { "Orders" }
                  end
                  render PhlexKit::BreadcrumbSeparator.new
                  render PhlexKit::BreadcrumbItem.new do
                    render PhlexKit::BreadcrumbPage.new { "#HB-1042" }
                  end
                end
              end
              div(class: "adm-row adm-detail-meta") do
                h1(class: "adm-detail-title") { "Ada Thornton" }
                status_badge("Paid")
                span(class: "adm-muted") { "Jun 28, 09:12 · 3 items · $182.00" }
              end
            end
            render PhlexKit::ButtonGroup.new do
              render PhlexKit::Button.new(
                variant: :outline, size: :sm,
                onclick: safe("PhlexKit.toast.success('Order fulfilled', { description: '#HB-1042 handed to the courier queue.' })")
              ) { "Fulfill" }
              render PhlexKit::Button.new(
                variant: :outline, size: :sm,
                onclick: safe("PhlexKit.toast.warning('Refund drafted', { description: 'Review the $182.00 refund before it sends.' })")
              ) { "Refund" }
              render PhlexKit::DropdownMenu.new do
                render PhlexKit::DropdownMenuTrigger.new do
                  render PhlexKit::Button.new(variant: :outline, size: :sm, icon: true, aria: { label: "More" }) do
                    icon(:ellipsis, size: 14)
                  end
                end
                render PhlexKit::DropdownMenuContent.new(class: "adm-more-menu") do
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Duplicate order" }
                  render PhlexKit::DropdownMenuItem.new(href: "#") { "Print packing slip" }
                  render PhlexKit::DropdownMenuSeparator.new
                  render PhlexKit::DropdownMenuItem.new(href: "#", variant: :destructive) { "Cancel order" }
                end
              end
            end
          end

          div(class: "adm-pin-scroll") do
            render PhlexKit::Card.new do
              render PhlexKit::CardHeader.new do
                render PhlexKit::CardTitle.new { "Items" }
              end
              render PhlexKit::CardContent.new do
                render PhlexKit::Table.new do
                  render PhlexKit::TableBody.new do
                    LINE_ITEMS.each do |name, qty, price|
                      render PhlexKit::TableRow.new do
                        render PhlexKit::TableCell.new { name }
                        render PhlexKit::TableCell.new(class: "adm-num adm-muted") { "×#{qty}" }
                        render PhlexKit::TableCell.new(class: "adm-num") { price }
                      end
                    end
                  end
                  render PhlexKit::TableFooter.new do
                    render PhlexKit::TableRow.new do
                      render PhlexKit::TableCell.new { "Total" }
                      render PhlexKit::TableCell.new { "" }
                      render PhlexKit::TableCell.new(class: "adm-num") { "$182.00" }
                    end
                  end
                end
              end
            end

            div(class: "adm-detail-duo") do
              render PhlexKit::Card.new do
                render PhlexKit::CardHeader.new do
                  render PhlexKit::CardTitle.new { "Customer" }
                end
                render PhlexKit::CardContent.new(class: "adm-stack") do
                  render PhlexKit::Item.new(size: :sm) do
                    render PhlexKit::ItemMedia.new do
                      render PhlexKit::Avatar.new(size: :sm) { render PhlexKit::AvatarFallback.new { "AT" } }
                    end
                    render PhlexKit::ItemContent.new do
                      render PhlexKit::ItemTitle.new { "Ada Thornton" }
                      render PhlexKit::ItemDescription.new { "8 orders · customer for 2 years" }
                    end
                  end
                  render PhlexKit::Separator.new
                  address(class: "adm-address") do
                    plain "14 Quayside Walk"
                    br
                    plain "Bristol BS1 4DB, United Kingdom"
                  end
                end
              end

              render PhlexKit::Card.new do
                render PhlexKit::CardHeader.new do
                  render PhlexKit::CardTitle.new { "Timeline" }
                end
                render PhlexKit::CardContent.new do
                  render PhlexKit::ItemGroup.new do
                    TIMELINE.each_with_index do |(glyph, title, detail), i|
                      render PhlexKit::ItemSeparator.new if i.positive?
                      render PhlexKit::Item.new(size: :sm) do
                        render PhlexKit::ItemMedia.new(variant: :icon) { icon(glyph) }
                        render PhlexKit::ItemContent.new do
                          render PhlexKit::ItemTitle.new { title }
                          render PhlexKit::ItemDescription.new { detail }
                        end
                      end
                    end
                  end
                end
              end
            end

            render PhlexKit::Field.new do
              render PhlexKit::FieldLabel.new(for: "inbox-note") { "Internal note" }
              render PhlexKit::Textarea.new(id: "inbox-note", rows: 3, placeholder: "Only your team can see this…")
              render PhlexKit::FieldDescription.new { "Notes attach to the order, not the customer." }
            end
          end

          footer(class: "adm-pin-footer") do
            render PhlexKit::Button.new(variant: :ghost, size: :sm) { "Cancel order" }
            render PhlexKit::Button.new(
              size: :sm,
              onclick: safe("PhlexKit.toast.success('Order fulfilled', { description: '#HB-1042 handed to the courier queue.' })")
            ) { "Mark fulfilled" }
          end
        end
      end

      def local_css
        <<~CSS
          .adm-inbox { display: flex; flex-direction: column; height: 100dvh; min-width: 0; }
          .adm-inbox > .adm-split { flex: 1; }
          .adm-list-title { margin: 0; font-size: 1rem; font-weight: 600; }
          .adm-list-search { flex: 1; }
          .adm-inbox-row { border-radius: calc(var(--pk-radius) - 2px); }
          .adm-inbox-row.active { background: var(--pk-accent); }
          .adm-detail-meta { margin-top: .5rem; }
          .adm-detail-title { margin: 0; font-size: 1.125rem; font-weight: 600; }
          .adm-detail-duo { display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; }
          .adm-more-menu { right: 0; left: auto; }
          .adm-address { font-style: normal; color: var(--pk-muted); font-size: .8125rem; line-height: 1.6; }
          @media (max-width: 900px) { .adm-detail-duo { grid-template-columns: 1fr; } }
        CSS
      end
    end
  end
end
