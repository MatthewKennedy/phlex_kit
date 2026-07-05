# frozen_string_literal: true

module Examples
  # Shared document chrome for the /examples pages: every page is a screen of
  # "Harbor", a fictional commerce admin, so they share nav vocabulary, sample
  # data and the .adm-* layout CSS (grid frames ported from
  # grid-layout/admin-ui; everything visible is a PhlexKit component).
  class BasePage < Phlex::HTML
    include Phlex::Rails::Helpers::StylesheetLinkTag
    include Phlex::Rails::Helpers::JavaScriptImportmapTags
    include Phlex::Rails::Helpers::JavaScriptIncludeTag
    include Phlex::Rails::Helpers::AssetPath

    # Harbor's nav — each entry deep-links to the example that plays that
    # screen, so the six pages navigate like one app.
    NAV = [
      [ :home, "Dashboard", "dashboard-cards" ],
      [ :shopping_cart, "Orders", "sidebar-header" ],
      [ :mail, "Inbox", "master-detail" ],
      [ :users, "Customers", "holy-grail" ],
      [ :chart, "Reports", "header-top" ],
      [ :settings, "Settings", "settings-form" ]
    ].freeze

    # One shared order book — the table on Orders, the feed on Dashboard and
    # the inbox on Orders inbox all draw from it.
    ORDERS = [
      [ "#HB-1042", "Ada Thornton", "Paid", 3, "$182.00", "Jun 28" ],
      [ "#HB-1041", "Marcus Webb", "Pending", 1, "$49.00", "Jun 28" ],
      [ "#HB-1040", "Priya Nair", "Fulfilled", 5, "$310.50", "Jun 27" ],
      [ "#HB-1039", "Tom Okafor", "Paid", 2, "$96.00", "Jun 27" ],
      [ "#HB-1038", "Lena Fischer", "Refunded", 1, "$58.00", "Jun 26" ],
      [ "#HB-1037", "Sam Kowalski", "Paid", 4, "$204.75", "Jun 26" ],
      [ "#HB-1036", "Ida Blom", "Fulfilled", 2, "$88.00", "Jun 25" ],
      [ "#HB-1035", "Ravi Patel", "Pending", 6, "$412.20", "Jun 25" ],
      [ "#HB-1034", "June Park", "Paid", 1, "$29.00", "Jun 24" ],
      [ "#HB-1033", "Omar Haddad", "Fulfilled", 3, "$150.00", "Jun 24" ]
    ].freeze

    STATUS_VARIANTS = {
      "Paid" => :success, "Fulfilled" => :secondary,
      "Pending" => :warning, "Refunded" => :destructive
    }.freeze

    def view_template
      doctype
      html(data_theme: "dark") do
        head do
          title { "#{page_title} — Harbor · PhlexKit examples" }
          meta(charset: "utf-8")
          meta(name: "viewport", content: "width=device-width,initial-scale=1")
          stylesheet_link_tag "phlex_kit/phlex_kit"
          stylesheet_link_tag "phlex_kit/themes/#{ENV["PK_THEME"]}" if ENV["PK_THEME"]
          javascript_include_tag "chartjs.umd"
          javascript_importmap_tags
          style { safe(shared_css + local_css) }
        end
        body do
          body_content
          render PhlexKit::ToastRegion.new(close_button: true)
        end
      end
    end

    private

    # Subclass contract.
    def page_title = raise NotImplementedError
    def body_content = raise NotImplementedError
    def local_css = ""

    def icon(name, size: 16, **attrs) = render(PhlexKit::Icon.new(name, size: size, **attrs))

    def status_badge(status)
      render PhlexKit::Badge.new(variant: STATUS_VARIANTS.fetch(status), size: :sm) { status }
    end

    # The Harbor rail — pages with a sidebar frame render this inside their
    # own PhlexKit::SidebarWrapper.
    def harbor_sidebar(active:)
      render PhlexKit::Sidebar.new(class: "adm-sidebar") do
        render PhlexKit::SidebarHeader.new do
          a(href: "/examples", class: "adm-brand") do
            span(class: "adm-brand-mark") { icon(:globe, size: 14) }
            plain "Harbor"
          end
          render PhlexKit::ThemeToggle.new { "🌓" }
        end
        render PhlexKit::SidebarContent.new do
          render PhlexKit::SidebarGroup.new do
            render PhlexKit::SidebarGroupLabel.new { "Store" }
            render PhlexKit::SidebarGroupContent.new do
              render PhlexKit::SidebarMenu.new do
                NAV.each do |icon_name, label, slug|
                  render PhlexKit::SidebarMenuItem.new do
                    render PhlexKit::SidebarMenuButton.new(as: :a, href: "/examples/#{slug}", active: slug == active, tooltip: label) do
                      icon(icon_name)
                      span { label }
                    end
                  end
                end
              end
            end
          end
        end
        render PhlexKit::SidebarFooter.new do
          div(class: "adm-user") do
            render PhlexKit::Avatar.new(size: :sm) { render PhlexKit::AvatarFallback.new { "MK" } }
            div(class: "adm-user-meta") do
              span(class: "adm-user-name") { "Mae Keller" }
              span(class: "adm-user-role") { "Store owner" }
            end
          end
          a(href: "/examples", class: "adm-footer-link") { "← All examples" }
        end
      end
    end

    # Top bar for the sidebar-less frames (02, 03, 06) and the index.
    def harbor_topbar(&block)
      header(class: "adm-topbar") do
        a(href: "/examples", class: "adm-brand") do
          span(class: "adm-brand-mark") { icon(:globe, size: 14) }
          plain "Harbor"
        end
        if block
          yield
        else
          div(class: "adm-topbar-spacer")
        end
        render PhlexKit::ThemeToggle.new { "🌓" }
        render PhlexKit::Avatar.new(size: :sm) { render PhlexKit::AvatarFallback.new { "MK" } }
      end
    end

    def harbor_footer(note)
      footer(class: "adm-footer") { note }
    end

    # Page frames ported from grid-layout/admin-ui (grid-layout-base.css);
    # chrome for these pages only — colors ride the --pk-* tokens so both
    # themes and every bundled theme file just work.
    def shared_css
      <<~CSS
        @font-face { font-family: "Geist"; src: url("#{asset_path("geist-variable.woff2")}") format("woff2");
                     font-weight: 100 900; font-display: swap; }
        @font-face { font-family: "Geist Mono"; src: url("#{asset_path("geist-mono-variable.woff2")}") format("woff2");
                     font-weight: 100 900; font-display: swap; }
        :root { --pk-font-sans: "Geist", ui-sans-serif, system-ui, sans-serif;
                --pk-font-mono: "Geist Mono", ui-monospace, monospace; }
        body { margin: 0; background: var(--pk-bg); color: var(--pk-text);
               font: 14px/1.5 var(--pk-font-sans); }
        a { color: inherit; }
        /* The kit's border-box reset is scoped to pk-*; mirror it for the
           page's own adm-* frames (width:100% + padding must not overflow). */
        [class^="adm-"], [class*=" adm-"],
        [class^="adm-"] *, [class*=" adm-"] * { box-sizing: border-box; }

        /* Shared chrome */
        .adm-brand { display: inline-flex; align-items: center; gap: .5rem; font-weight: 700;
                     font-size: .9375rem; color: var(--pk-text); text-decoration: none; margin-right: auto; }
        .adm-brand-mark { display: inline-flex; align-items: center; justify-content: center;
                          width: 1.5rem; height: 1.5rem; border-radius: calc(var(--pk-radius) - 2px);
                          background: var(--pk-brand); color: var(--pk-brand-ink); }
        .adm-topbar { display: flex; align-items: center; gap: 1rem; padding: .625rem 1.25rem;
                      border-bottom: 1px solid var(--pk-border); background: var(--pk-bg);
                      position: sticky; top: 0; z-index: 40; }
        .adm-topbar-spacer { flex: 1; }
        .adm-footer { padding: .875rem 1.5rem; border-top: 1px solid var(--pk-border);
                      color: var(--pk-muted); font-size: .75rem; }
        .adm-sidebar { height: 100dvh; position: sticky; top: 0; }
        .adm-user { display: flex; align-items: center; gap: .5rem; padding: .25rem; }
        .adm-user-meta { display: flex; flex-direction: column; line-height: 1.25; min-width: 0; }
        .adm-user-name { font-size: .8125rem; font-weight: 500; }
        .adm-user-role { font-size: .6875rem; color: var(--pk-muted); }
        .adm-footer-link { display: block; padding: .25rem; color: var(--pk-muted);
                           font-size: .75rem; text-decoration: none; }
        .adm-footer-link:hover { color: var(--pk-text); }

        /* Content rhythm */
        .adm-main { padding: 1.5rem; display: flex; flex-direction: column; gap: 1.25rem; min-width: 0; }
        .adm-page-head { display: flex; flex-wrap: wrap; align-items: center; gap: .75rem; }
        .adm-page-title { margin: 0; font-size: 1.375rem; font-weight: 600; letter-spacing: -.02em; }
        .adm-page-sub { margin: .125rem 0 0; color: var(--pk-muted); font-size: .8125rem; }
        .adm-head-actions { margin-left: auto; display: flex; align-items: center; gap: .5rem; }
        .adm-row { display: flex; align-items: center; gap: .5rem; }
        .adm-between { display: flex; align-items: center; justify-content: space-between; gap: .75rem; }
        .adm-stack { display: flex; flex-direction: column; gap: .75rem; }
        .adm-muted { color: var(--pk-muted); }
        .adm-mono { font-family: var(--pk-font-mono); font-size: .8125rem; }
        .adm-num { text-align: right; font-variant-numeric: tabular-nums; }

        /* 02 header-top: full-height rows auto|1fr|auto */
        .adm-page { display: grid; grid-template-rows: auto 1fr auto; min-height: 100dvh; }

        /* 03 holy grail: header / nav|main|aside / footer */
        .adm-holygrail { display: grid; min-height: 100dvh;
                         grid-template-areas: "header header header" "nav main aside" "footer footer footer";
                         grid-template-columns: 220px minmax(0, 1fr) 300px;
                         grid-template-rows: auto 1fr auto; }
        .adm-hg-nav { grid-area: nav; border-right: 1px solid var(--pk-border); padding: 1.25rem .75rem; }
        .adm-hg-main { grid-area: main; }
        .adm-hg-aside { grid-area: aside; border-left: 1px solid var(--pk-border);
                        padding: 1.5rem 1.25rem; display: flex; flex-direction: column; gap: 1rem; }
        .adm-holygrail > .adm-topbar { grid-area: header; }
        .adm-holygrail > .adm-footer { grid-area: footer; }
        @media (max-width: 1024px) {
          .adm-holygrail { grid-template-areas: "header header" "nav main" "nav aside" "footer footer";
                           grid-template-columns: 220px minmax(0, 1fr); grid-template-rows: auto 1fr auto auto; }
          .adm-hg-aside { border-left: 0; border-top: 1px solid var(--pk-border); }
        }
        @media (max-width: 768px) {
          .adm-holygrail { grid-template-areas: "header" "nav" "main" "aside" "footer";
                           grid-template-columns: minmax(0, 1fr); grid-template-rows: auto auto 1fr auto auto; }
          .adm-hg-nav { border-right: 0; border-bottom: 1px solid var(--pk-border); }
        }

        /* 06 settings rail: header / sticky-aside|main / footer */
        .adm-rail { display: grid; min-height: 100dvh;
                    grid-template-areas: "header header" "aside main" "footer footer";
                    grid-template-columns: 220px minmax(0, 1fr); grid-template-rows: auto 1fr auto; }
        .adm-rail > .adm-topbar { grid-area: header; }
        .adm-rail > .adm-footer { grid-area: footer; }
        .adm-rail-nav { grid-area: aside; padding: 1.5rem .75rem; }
        .adm-rail-nav-inner { position: sticky; top: 4rem; display: flex; flex-direction: column; gap: .125rem; }
        .adm-rail-main { grid-area: main; }
        @media (max-width: 768px) {
          .adm-rail { grid-template-areas: "header" "aside" "main" "footer";
                      grid-template-columns: minmax(0, 1fr); grid-template-rows: auto auto 1fr auto; }
          .adm-rail-nav-inner { position: static; flex-direction: row; flex-wrap: wrap; }
        }

        /* Section-nav links (03 nav + 06 rail) — sidebar-menu-button grammar. */
        .adm-nav-link { display: flex; align-items: center; gap: .5rem; padding: .375rem .5rem;
                        border-radius: calc(var(--pk-radius) - 2px); font-size: .8125rem;
                        color: var(--pk-text); text-decoration: none; }
        .adm-nav-link:hover { background: var(--pk-accent); }
        .adm-nav-link.active { background: var(--pk-accent); font-weight: 500; }

        /* 05 master–detail: list | detail, detail pinned header/body/footer */
        .adm-split { display: grid; grid-template-columns: 320px minmax(0, 1fr); flex: 1; min-height: 0; }
        .adm-list-pane { display: flex; flex-direction: column; gap: .75rem; min-height: 0;
                         border-right: 1px solid var(--pk-border); padding: 1rem; }
        .adm-list-scroll { overflow-y: auto; min-height: 0; margin: 0 -.5rem; padding: 0 .5rem; }
        .adm-pin { display: grid; grid-template-rows: auto minmax(0, 1fr) auto; min-height: 0; }
        .adm-pin-header { padding: 1rem 1.5rem; border-bottom: 1px solid var(--pk-border); }
        .adm-pin-scroll { overflow-y: auto; min-height: 0; padding: 1.5rem;
                          display: flex; flex-direction: column; gap: 1.25rem; }
        .adm-pin-scroll > * { flex: none; } /* children overflow into scroll, never squash */
        .adm-pin-footer { padding: .875rem 1.5rem; border-top: 1px solid var(--pk-border);
                          display: flex; gap: .5rem; justify-content: flex-end; background: var(--pk-bg); }
        @media (max-width: 768px) {
          .adm-split { grid-template-columns: minmax(0, 1fr); }
          .adm-list-pane { border-right: 0; border-bottom: 1px solid var(--pk-border); max-height: 45dvh; }
        }

        /* 04 dashboard: KPI auto-fit row + bento grid */
        .adm-kpis { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 1rem; }
        .adm-bento { display: grid; grid-template-columns: repeat(3, 1fr);
                     grid-auto-rows: minmax(140px, auto); gap: 1rem; }
        .adm-span-2 { grid-column: span 2; }
        .adm-rspan-2 { grid-row: span 2; }
        @media (max-width: 1024px) {
          .adm-bento { grid-template-columns: repeat(2, 1fr); }
          .adm-span-2 { grid-column: span 2; }
        }
        @media (max-width: 768px) {
          .adm-bento { grid-template-columns: minmax(0, 1fr); }
          .adm-span-2 { grid-column: auto; }
          .adm-rspan-2 { grid-row: auto; }
        }
      CSS
    end
  end
end
