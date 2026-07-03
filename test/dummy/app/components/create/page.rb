# frozen_string_literal: true

module Create
  # A PhlexKit recreation of ui.shadcn.com/create: a top navbar (with docs
  # navigation + ⌘K command palette), a floating theming menu whose knobs
  # actually work (?theme= swaps the bundled theme stylesheet, ?icons= swaps
  # the icon library per-request), and the demo dashboard canvas — every card
  # built from kit components.
  class Page < Phlex::HTML
    include Phlex::Rails::Helpers::StylesheetLinkTag
    include Phlex::Rails::Helpers::JavaScriptImportmapTags
    include Phlex::Rails::Helpers::JavaScriptIncludeTag
    include Phlex::Rails::Helpers::AssetPath

    THEMES = %w[neutral zinc claude].freeze
    ICON_LIBRARIES = %w[lucide tabler phosphor remix].freeze

    def initialize(theme: nil, icons: nil)
      @theme = theme
      @icons = icons
    end

    def view_template
      doctype
      html(data_theme: "dark") do
        head do
          title { "Create — PhlexKit" }
          meta(charset: "utf-8")
          meta(name: "viewport", content: "width=device-width,initial-scale=1")
          stylesheet_link_tag "phlex_kit/phlex_kit"
          stylesheet_link_tag "phlex_kit/themes/#{@theme}" if @theme
          javascript_include_tag "chartjs.umd"
          javascript_importmap_tags
          style { safe(page_css) }
        end
        body do
          navbar
          menu_panel
          main(class: "cr-canvas") do
            tile { contribution_history_card }
            tile { payout_threshold_card }
            tile { savings_targets_card }
            tile { distribute_track_card }
            tile { claimable_balance_card }
            tile { recent_transactions_card }
            tile { qr_connect_card }
            tile { preferences_card }
            tile { quick_links_card }
            tile { dividend_income_card }
            tile { savings_goal_card }
            tile { faq_card }
            tile { dollar_cost_card }
            tile { kitchen_island_card }
            tile { holdings_search_card }
            tile { syncing_card }
          end
          page_dots
          render PhlexKit::ToastRegion.new(close_button: true)
        end
      end
    end

    private

    # Per-request icon library — Icon takes library: per instance, so the
    # ?icons= knob never mutates the kit-wide config.
    def icon(name, size: 16, **attrs)
      render PhlexKit::Icon.new(name, library: @icons&.to_sym, size: size, **attrs)
    end

    def tile(&block)
      div(class: "cr-tile", &block)
    end

    def query_for(theme:, icons:)
      params = {}
      params[:theme] = theme if theme
      params[:icons] = icons if icons
      params.empty? ? "/create" : "/create?#{params.map { |k, v| "#{k}=#{v}" }.join("&")}"
    end

    # --- navbar ------------------------------------------------------------

    def navbar
      header(class: "cr-nav") do
        a(href: "/", class: "cr-brand") { "PhlexKit" }
        render PhlexKit::NavigationMenu.new do
          render PhlexKit::NavigationMenuList.new do
            render PhlexKit::NavigationMenuItem.new do
              render PhlexKit::NavigationMenuLink.new(href: "/") { "Docs" }
            end
            render PhlexKit::NavigationMenuItem.new do
              render PhlexKit::NavigationMenuTrigger.new { "Components" }
              render PhlexKit::NavigationMenuContent.new(class: "cr-nav-grid") do
                Docs::Registry.all.each do |slug, entry|
                  render PhlexKit::NavigationMenuLink.new(href: "/docs/#{slug}") { entry[:title] }
                end
              end
            end
            render PhlexKit::NavigationMenuItem.new do
              render PhlexKit::NavigationMenuLink.new(href: "/gallery") { "Gallery" }
            end
            render PhlexKit::NavigationMenuItem.new do
              render PhlexKit::NavigationMenuLink.new(href: "/create", class: "active") { "Create" }
            end
          end
        end
        div(class: "cr-nav-spacer")
        search_command
        render PhlexKit::ThemeToggle.new(aria: { label: "Toggle theme" }) { icon(:sun, size: 15) }
        a(href: "https://github.com/MatthewKennedy/phlex_kit", class: "pk-button ghost sm", target: "_blank", rel: "noopener") do
          icon(:external_link, size: 14)
          plain " GitHub"
        end
        get_code_dialog
      end
    end

    def search_command
      render PhlexKit::CommandDialog.new do
        render PhlexKit::CommandDialogTrigger.new do
          button(type: "button", class: "cr-search") do
            icon(:search, size: 14)
            span { "Search documentation…" }
            render PhlexKit::KbdGroup.new do
              render PhlexKit::Kbd.new { "⌘" }
              render PhlexKit::Kbd.new { "K" }
            end
          end
        end
        render PhlexKit::CommandDialogContent.new do
          render PhlexKit::Command.new do
            render PhlexKit::CommandInput.new(placeholder: "Search documentation…")
            render PhlexKit::CommandList.new do
              render PhlexKit::CommandGroup.new(title: "Pages") do
                render PhlexKit::CommandItem.new(value: "docs home", href: "/") { "Docs" }
                render PhlexKit::CommandItem.new(value: "gallery kitchen sink", href: "/gallery") { "Gallery" }
                render PhlexKit::CommandItem.new(value: "create theme builder", href: "/create") { "Create" }
              end
              render PhlexKit::CommandGroup.new(title: "Components") do
                Docs::Registry.all.each do |slug, entry|
                  render PhlexKit::CommandItem.new(value: entry[:title].downcase, href: "/docs/#{slug}") { entry[:title] }
                end
              end
            end
            render PhlexKit::CommandEmpty.new { "No results found." }
          end
        end
      end
    end

    def get_code_dialog
      render PhlexKit::Dialog.new do
        render PhlexKit::DialogTrigger.new do
          render PhlexKit::Button.new(size: :sm) { "Get Code" }
        end
        render PhlexKit::DialogContent.new do
          render PhlexKit::DialogHeader.new do
            render PhlexKit::DialogTitle.new { "Install PhlexKit" }
            render PhlexKit::DialogDescription.new do
              plain "This look is the stock kit"
              plain @theme ? " with the bundled #{@theme} theme" : ""
              plain @icons && @icons != "lucide" ? " and #{@icons} icons" : ""
              plain ". No Tailwind, no build step."
            end
          end
          render PhlexKit::DialogMiddle.new do
            render PhlexKit::Codeblock.new(install_snippet, syntax: :ruby)
          end
          render PhlexKit::DialogFooter.new do
            render PhlexKit::Clipboard.new do
              div(class: "pk-hidden") { render PhlexKit::ClipboardSource.new { install_snippet } }
              render PhlexKit::ClipboardTrigger.new do
                render PhlexKit::Button.new(size: :sm, variant: :outline) { "Copy" }
              end
            end
            render PhlexKit::Button.new(size: :sm, data: { action: "click->phlex-kit--dialog#dismiss" }) { "Done" }
          end
        end
      end
    end

    def install_snippet
      lines = [ %(bundle add phlex_kit) ]
      lines << %(# app/assets/stylesheets/application.css\n# @import url("phlex_kit/themes/#{@theme}.css");) if @theme
      lines << %(PhlexKit.config.icon_library = :#{@icons}) if @icons && @icons != "lucide"
      lines.join("\n")
    end

    # --- theming menu panel --------------------------------------------------

    def menu_panel
      aside(class: "cr-menu") do
        div(class: "cr-menu-head") do
          span { "Menu" }
          icon(:menu, size: 16)
        end
        form(action: "/create", method: "get", class: "cr-menu-form") do
          knob("Theme") do
            render PhlexKit::NativeSelect.new(size: :sm, name: "theme", onchange: safe("this.form.submit()")) do
              render PhlexKit::NativeSelectOption.new(value: "", selected: @theme.nil?) { "Default" }
              THEMES.each do |t|
                render PhlexKit::NativeSelectOption.new(value: t, selected: t == @theme) { t.capitalize }
              end
            end
          end
          knob("Icon Library") do
            render PhlexKit::NativeSelect.new(size: :sm, name: "icons", onchange: safe("this.form.submit()")) do
              ICON_LIBRARIES.each do |lib|
                selected = lib == (@icons || "lucide")
                render PhlexKit::NativeSelectOption.new(value: lib, selected: selected) { lib.capitalize }
              end
            end
          end
        end
        render PhlexKit::Separator.new(class: "cr-menu-sep")
        div(class: "cr-menu-actions") do
          render PhlexKit::Button.new(variant: :outline, size: :sm, onclick: safe(shuffle_js)) { "Shuffle" }
          a(href: "/create", class: "pk-button ghost sm") { "Reset" }
        end
      end
    end

    def knob(label, &block)
      div(class: "cr-knob") do
        span(class: "cr-knob-label") { label }
        div(class: "cr-knob-control", &block)
      end
    end

    def shuffle_js
      themes = ([ "" ] + THEMES).inspect
      icons = ICON_LIBRARIES.inspect
      "const t = #{themes}[Math.floor(Math.random() * 4)], i = #{icons}[Math.floor(Math.random() * 4)]; " \
        "location.href = '/create?' + new URLSearchParams({ ...(t && { theme: t }), icons: i });"
    end

    # --- canvas cards --------------------------------------------------------

    def contribution_history_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Contribution History" }
          render PhlexKit::CardDescription.new { "Last 6 months of activity" }
        end
        render PhlexKit::CardContent.new do
          render PhlexKit::Chart.new(options: {
            type: "bar",
            data: {
              labels: %w[Dec Jan Feb Mar Apr May],
              datasets: [ { label: "Contributions", data: [ 620, 780, 640, 850, 590, 900 ], borderWidth: 0, borderRadius: 4 } ]
            },
            options: { plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } }, y: { display: false } } }
          })
          div(class: "cr-stat-row") do
            div(class: "cr-stat") do
              span(class: "cr-stat-label") { "Upcoming" }
              strong { "May 25, 2024" }
              span(class: "cr-stat-sub") { "$1,000 scheduled" }
            end
            div(class: "cr-stat") do
              span(class: "cr-stat-label") { "Auto-Save Plan" }
              strong { "Accelerated" }
              span(class: "cr-stat-sub") { "Recurring weekly" }
            end
          end
        end
        render PhlexKit::CardFooter.new do
          render PhlexKit::Button.new(class: "cr-full") { "View Full Report" }
        end
      end
    end

    def payout_threshold_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Payout Threshold" }
          render PhlexKit::CardDescription.new { "Set the minimum balance required before a payout is triggered." }
          render PhlexKit::CardAction.new do
            render PhlexKit::Button.new(variant: :ghost, size: :sm, icon: true, aria: { label: "Dismiss" }) { icon(:x, size: 14) }
          end
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Preferred Currency" }
            render PhlexKit::NativeSelect.new(name: "currency") do
              render PhlexKit::NativeSelectOption.new(value: "usd", selected: true) { "USD — United States Dollar" }
              render PhlexKit::NativeSelectOption.new(value: "eur") { "EUR — Euro" }
              render PhlexKit::NativeSelectOption.new(value: "gbp") { "GBP — Pound Sterling" }
            end
          end
          div(class: "cr-field") do
            div(class: "cr-between") do
              render PhlexKit::Label.new { "Minimum Payout Amount" }
              strong(class: "cr-amount") { "$2500.00" }
            end
            render PhlexKit::Slider.new(name: "threshold", min: 50, max: 10_000, step: 50, value: 2500)
            div(class: "cr-between cr-muted-sm") do
              span { "$50 (MIN)" }
              span { "$10,000 (MAX)" }
            end
          end
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Notes" }
            render PhlexKit::Textarea.new(rows: 3, placeholder: "Add any notes for this payout configuration…")
          end
        end
        render PhlexKit::CardFooter.new do
          render PhlexKit::Button.new(class: "cr-full") { "Save Threshold" }
        end
      end
    end

    def savings_targets_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Savings Targets" }
          render PhlexKit::CardDescription.new { "Active milestones for 2024" }
          render PhlexKit::CardAction.new do
            render PhlexKit::Button.new(variant: :outline, size: :sm) { "New" }
          end
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          [
            [ "Retirement", "$420,000", 65, "$273,000 saved" ],
            [ "Real Estate", "$85,000", 32, "$27,200 saved" ]
          ].each do |label, target, pct, saved|
            div(class: "cr-target") do
              span(class: "cr-stat-label") { label }
              strong(class: "cr-target-amount") { target }
              render PhlexKit::Progress.new(value: pct)
              div(class: "cr-between cr-muted-sm") do
                span { "#{pct}% achieved" }
                span { saved }
              end
            end
          end
        end
        render PhlexKit::CardFooter.new(class: "cr-muted-sm") do
          plain "You have not met your targets for this year."
        end
      end
    end

    def distribute_track_card
      render PhlexKit::Card.new do
        render PhlexKit::CardContent.new do
          render PhlexKit::Empty.new do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyMedia.new { icon(:plus, size: 20) }
              render PhlexKit::EmptyTitle.new { "Distribute Track" }
              render PhlexKit::EmptyDescription.new { "Upload your first master to start reaching listeners on Spotify, Apple Music, and more." }
            end
            render PhlexKit::EmptyContent.new do
              render PhlexKit::Button.new { "Upload Master" }
            end
          end
        end
      end
    end

    def claimable_balance_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardDescription.new { "Claimable Balance" }
          render PhlexKit::CardTitle.new(class: "cr-balance") { "$0.00" }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div { render PhlexKit::Badge.new(variant: :secondary) { "● Pending Setup" } }
          div(class: "cr-ledger") do
            div(class: "cr-between") do
              span(class: "cr-muted") { "Net Royalties" }
              span { "$0.00" }
            end
            render PhlexKit::Separator.new
            div(class: "cr-between") do
              span(class: "cr-muted") { "Total Ready to Claim" }
              strong { "$0.00 USD" }
            end
          end
          div(class: "cr-note") do
            plain "Once your bank is connected, balances over $10.00 are automatically eligible for monthly distribution on the 15th of each month."
          end
        end
      end
    end

    def recent_transactions_card
      transactions = [
        [ :heart, "Blue Bottle Coffee", "Food & Drink" ],
        [ :shopping_cart, "Whole Foods Market", "Groceries" ],
        [ :credit_card, "Stripe Payout", "Income" ],
        [ :map_pin, "Uber Trip", "Transport" ],
        [ :play, "Netflix Subscription", "Entertainment" ]
      ]
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Recent Transactions" }
          render PhlexKit::CardDescription.new { "Your latest account activity." }
        end
        render PhlexKit::CardContent.new do
          render PhlexKit::ItemGroup.new do
            transactions.each do |glyph, title, category|
              render PhlexKit::Item.new do
                render PhlexKit::ItemMedia.new(class: "cr-tx-icon") { icon(glyph) }
                render PhlexKit::ItemContent.new do
                  render PhlexKit::ItemTitle.new { title }
                  render PhlexKit::ItemDescription.new { category }
                end
              end
            end
          end
        end
      end
    end

    def qr_connect_card
      render PhlexKit::Card.new do
        render PhlexKit::CardContent.new(class: "cr-center cr-stack") do
          qr_svg
          strong { "Scan to connect your mobile device" }
          p(class: "cr-muted-sm cr-center-text") { "Open the Ledger mobile app and scan this code to link your device." }
        end
        render PhlexKit::CardFooter.new do
          render PhlexKit::Button.new(variant: :secondary, class: "cr-full") { "Got it" }
        end
      end
    end

    # A deterministic QR-looking pattern: three finder squares + hashed modules.
    def qr_svg
      size = 21
      svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 #{size} #{size}", class: "cr-qr", "aria-hidden": "true") do |s|
        finder = ->(ox, oy) do
          s.rect(x: ox, y: oy, width: 7, height: 7, fill: "currentColor")
          s.rect(x: ox + 1, y: oy + 1, width: 5, height: 5, fill: "var(--pk-surface)")
          s.rect(x: ox + 2, y: oy + 2, width: 3, height: 3, fill: "currentColor")
        end
        finder.call(0, 0)
        finder.call(size - 7, 0)
        finder.call(0, size - 7)
        size.times do |x|
          size.times do |y|
            next if (x < 8 && y < 8) || (x >= size - 8 && y < 8) || (x < 8 && y >= size - 8)
            s.rect(x: x, y: y, width: 1, height: 1, fill: "currentColor") if ((x * 31) ^ (y * 17)) % 3 == 0
          end
        end
      end
    end

    def preferences_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Preferences" }
          render PhlexKit::CardDescription.new { "Manage your account settings and notifications." }
          render PhlexKit::CardAction.new do
            render PhlexKit::Button.new(variant: :ghost, size: :sm, icon: true, aria: { label: "Dismiss" }) { icon(:x, size: 14) }
          end
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Default Currency" }
            render PhlexKit::NativeSelect.new(name: "default_currency") do
              render PhlexKit::NativeSelectOption.new(value: "usd", selected: true) { "USD — United States Dollar" }
              render PhlexKit::NativeSelectOption.new(value: "eur") { "EUR — Euro" }
            end
          end
          [
            [ "Public Statistics", "Allow others to see your total stream count and listening activity." ],
            [ "Email Notifications", "Monthly royalty reports and distribution updates." ]
          ].each do |title, description|
            div(class: "cr-switch-row") do
              div do
                strong(class: "cr-switch-title") { title }
                p(class: "cr-muted-sm") { description }
              end
              render PhlexKit::Switch.new(name: title.parameterize(separator: "_"), checked: true)
            end
          end
        end
        render PhlexKit::CardFooter.new(class: "cr-between") do
          render PhlexKit::Button.new(variant: :outline, size: :sm) { "Reset" }
          render PhlexKit::Button.new(size: :sm) { "Save Preferences" }
        end
      end
    end

    def quick_links_card
      groups = {
        "Overview" => [ [ :home, "Dashboard", true ], [ :refresh, "Transactions" ], [ :chart, "Investments" ], [ :database, "Accounts" ], [ :credit_card, "Spending" ] ],
        "Planning" => [ [ :star, "Goals" ], [ :calendar, "Budget" ], [ :file, "Reports" ], [ :folder, "Documents" ] ],
        "Account" => [ [ :user, "Profile" ], [ :credit_card, "Billing", true ], [ :bell, "Notifications" ], [ :shield, "Security" ], [ :eye, "Appearance" ] ],
        "Support" => [ [ :info, "Help Center" ], [ :mail, "Contact Us" ], [ :bookmark, "Documentation" ], [ :globe, "Status" ] ]
      }
      render PhlexKit::Card.new do
        render PhlexKit::CardContent.new(class: "cr-links-grid") do
          groups.each do |group, items|
            div(class: "cr-links-group") do
              span(class: "cr-stat-label") { group }
              items.each do |glyph, label, active|
                a(href: "#", class: "cr-link-item#{" active" if active}") do
                  icon(glyph, size: 15)
                  span { label }
                end
              end
            end
          end
        end
      end
    end

    def dividend_income_card
      holdings = [
        [ "Vanguard VIG", "450 Shares", [ 40, 55, 45, 90 ], "$1,842.10" ],
        [ "S&P 500 VOO", "112 Shares", [ 45, 50, 85, 55 ], "$928.40" ],
        [ "Apple AAPL", "85 Shares", [ 50, 50, 60, 55 ], "$340.00" ],
        [ "Realty Income", "320 Shares", [ 45, 55, 60, 95 ], "$1,139.50" ]
      ]
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Q2 Dividend Income" }
          render PhlexKit::CardDescription.new { "Quarterly dividend payouts across your portfolio holdings." }
          render PhlexKit::CardAction.new do
            render PhlexKit::Button.new(variant: :ghost, size: :sm, icon: true, aria: { label: "Dismiss" }) { icon(:x, size: 14) }
          end
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          holdings.each do |name, shares, bars, amount|
            div(class: "cr-holding") do
              div do
                strong(class: "cr-holding-name") { name }
                span(class: "cr-muted-sm") { shares }
              end
              div(class: "cr-spark") do
                bars.each { |h| span(style: "height: #{h}%") }
              end
              strong(class: "cr-holding-amount") { amount }
            end
          end
        end
      end
    end

    def savings_goal_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Emergency Fund" }
          render PhlexKit::CardDescription.new { "Progress toward your $30,000 goal" }
        end
        render PhlexKit::CardContent.new do
          div(class: "cr-donut") do
            render PhlexKit::Chart.new(options: {
              type: "doughnut",
              data: { labels: %w[Saved Remaining], datasets: [ { data: [ 24_000, 6_000 ], borderWidth: 0 } ] },
              options: { cutout: "72%", plugins: { legend: { display: false } } }
            })
            div(class: "cr-donut-label") { "$24,000" }
          end
          div(class: "cr-ledger") do
            [ [ "Projected Finish", "October 2024" ], [ "Monthly Average", "$1,250" ], [ "Top Contributor", "Auto-Transfer" ] ].each_with_index do |(label, value), i|
              render PhlexKit::Separator.new if i.positive?
              div(class: "cr-between") do
                span(class: "cr-muted") { label }
                strong { value }
              end
            end
          end
        end
      end
    end

    def faq_card
      render PhlexKit::Card.new do
        render PhlexKit::CardContent.new do
          render PhlexKit::Tabs.new(default: "general") do
            render PhlexKit::TabsList.new do
              render PhlexKit::TabsTrigger.new(value: "general") { "General" }
              render PhlexKit::TabsTrigger.new(value: "billing") { "Billing" }
              render PhlexKit::TabsTrigger.new(value: "goals") { "Goals" }
            end
            render PhlexKit::TabsContent.new(value: "general") do
              faq_accordion(
                [ "How secure is my financial data with Ledger?",
                  "We use bank-level AES-256 encryption, SOC 2 certified infrastructure, and never store your credentials. All connections use read-only access tokens. We are a SEC registered advisor.", true ],
                [ "Can I connect multiple bank accounts?",
                  "Yes — connect as many institutions as you like; balances aggregate automatically." ],
                [ "Can I export my data for tax purposes?",
                  "CSV and PDF exports are available for every statement period." ]
              )
            end
            render PhlexKit::TabsContent.new(value: "billing") do
              faq_accordion(
                [ "When am I charged?", "On the first of each month, for the previous month's usage.", true ],
                [ "Do you offer refunds?", "Within 30 days of any annual-plan purchase, no questions asked." ]
              )
            end
            render PhlexKit::TabsContent.new(value: "goals") do
              faq_accordion(
                [ "How are goal projections calculated?", "From your trailing 6-month average contribution rate.", true ]
              )
            end
          end
        end
        render PhlexKit::CardFooter.new do
          render PhlexKit::Button.new(variant: :outline, class: "cr-full") { "Contact Support" }
        end
      end
    end

    def faq_accordion(*entries)
      render PhlexKit::Accordion.new do
        entries.each do |question, answer, open|
          render PhlexKit::AccordionItem.new(open: !!open) do
            render PhlexKit::AccordionDefaultTrigger.new { question }
            render PhlexKit::AccordionContent.new do
              render PhlexKit::AccordionDefaultContent.new { answer }
            end
          end
        end
      end
    end

    def dollar_cost_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Dollar-Cost Averaging" }
          render PhlexKit::CardDescription.new { "A strategy for building wealth over time." }
        end
        render PhlexKit::CardContent.new(class: "cr-prose") do
          p do
            render PhlexKit::HoverCard.new do
              render PhlexKit::HoverCardTrigger.new(class: "cr-defined") do
                plain "Over time"
              end
              render PhlexKit::HoverCardContent.new do
                plain "Typically 5+ years — long enough for market cycles to average out."
              end
            end
            plain ", this smooths out the average cost of your investments. When prices drop, your fixed amount buys more shares. When prices rise, you buy fewer. The result is a lower average cost per share compared to lump-sum investing during volatile periods."
          end
        end
      end
    end

    def kitchen_island_card
      sliders = [ [ :sun, "Brightness", 85 ], [ :cloud, "Color Temp", 65 ], [ :mic, "Volume", 30 ], [ :moon, "Fade", 5 ] ]
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Kitchen Island" }
          render PhlexKit::CardDescription.new { "Hue Color Ambient" }
          render PhlexKit::CardAction.new do
            render PhlexKit::Switch.new(name: "island", checked: true)
          end
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          render PhlexKit::ToggleGroup.new(type: :single, name: "scene", value: "cooking") do |group|
            group.ToggleGroupItem(value: "cooking") { "Cooking" }
            group.ToggleGroupItem(value: "dining") { "Dining" }
            group.ToggleGroupItem(value: "nightlight") { "Nightlight" }
            group.ToggleGroupItem(value: "focus") { "Focus" }
          end
          sliders.each do |glyph, label, value|
            div(class: "cr-slider-row") do
              icon(glyph, size: 15)
              span(class: "cr-slider-label") { label }
              render PhlexKit::Slider.new(name: label.parameterize(separator: "_"), value: value)
            end
          end
        end
      end
    end

    def holdings_search_card
      holdings = [
        [ "VOO", "Vanguard S&P 500 ETF", "112 SHARES · JAN 2021" ],
        [ "VIG", "Vanguard Dividend Appreciation", "450 SHARES · MAR 2022" ],
        [ "AAPL", "Apple Inc.", "85 SHARES · NOV 2020" ],
        [ "O", "Realty Income Corp", "320 SHARES · JUN 2023" ]
      ]
      render PhlexKit::Card.new do
        render PhlexKit::CardContent.new(class: "cr-stack") do
          render PhlexKit::InputGroup.new do
            render PhlexKit::InputGroupAddon.new { icon(:search, size: 14) }
            render PhlexKit::Input.new(placeholder: "Search holdings or tickers…", name: "holdings_search")
          end
          render PhlexKit::ItemGroup.new do
            holdings.each do |ticker, name, detail|
              render PhlexKit::Item.new(variant: :outline) do
                render PhlexKit::ItemMedia.new do
                  render PhlexKit::Avatar.new(size: :sm) { render PhlexKit::AvatarFallback.new { ticker } }
                end
                render PhlexKit::ItemContent.new do
                  render PhlexKit::ItemTitle.new { name }
                  render PhlexKit::ItemDescription.new { detail }
                end
              end
            end
          end
        end
      end
    end

    def syncing_card
      render PhlexKit::Card.new do
        render PhlexKit::CardContent.new(class: "cr-center cr-stack") do
          render PhlexKit::Spinner.new
          strong { "Syncing your accounts" }
          p(class: "cr-muted-sm cr-center-text") { "We're pulling in your latest transactions. This usually takes a few seconds." }
          render PhlexKit::Button.new(variant: :outline, size: :sm) { "Cancel" }
        end
      end
    end

    def page_dots
      div(class: "cr-dots") do
        span(class: "cr-dot active") { "01" }
        span(class: "cr-dot") { "02" }
      end
    end

    # Chrome for this page only — not part of the kit.
    def page_css
      <<~CSS
        @font-face { font-family: "Geist"; src: url("#{asset_path("geist-variable.woff2")}") format("woff2");
                     font-weight: 100 900; font-display: swap; }
        @font-face { font-family: "Geist Mono"; src: url("#{asset_path("geist-mono-variable.woff2")}") format("woff2");
                     font-weight: 100 900; font-display: swap; }
        :root { --pk-font-sans: "Geist", ui-sans-serif, system-ui, sans-serif;
                --pk-font-mono: "Geist Mono", ui-monospace, monospace; }
        body { margin: 0; background: var(--pk-bg); color: var(--pk-text); font: 15px/1.5 var(--pk-font-sans); }

        /* navbar */
        .cr-nav { position: sticky; top: 0; z-index: 40; display: flex; align-items: center; gap: .75rem;
                  padding: .5rem 1.5rem; border-bottom: 1px solid var(--pk-border);
                  background: color-mix(in oklab, var(--pk-bg) 85%, transparent); backdrop-filter: blur(8px); }
        .cr-brand { font-weight: 700; color: var(--pk-text); text-decoration: none; margin-right: .5rem; }
        .cr-nav-spacer { flex: 1; }
        .cr-nav .pk-navigation-menu a.active { color: var(--pk-text); font-weight: 600; }
        .cr-nav-grid { display: grid; grid-template-columns: repeat(4, minmax(140px, 1fr));
                       gap: 0 .5rem; max-height: 60vh; overflow-y: auto; min-width: 620px; }
        .cr-search { display: flex; align-items: center; gap: .5rem; min-width: 240px;
                     padding: .375rem .625rem; font: inherit; font-size: .8125rem; color: var(--pk-muted);
                     background: var(--pk-surface-2, var(--pk-surface)); border: 1px solid var(--pk-input);
                     border-radius: calc(var(--pk-radius) - 2px); cursor: pointer; }
        .cr-search span { flex: 1; text-align: left; }

        /* theming menu */
        .cr-menu { position: fixed; left: 1.5rem; top: 5rem; z-index: 30; width: 200px;
                   padding: 1rem; border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) + 4px);
                   background: var(--pk-surface); box-shadow: 0 8px 30px rgb(0 0 0 / .12); }
        .cr-menu-head { display: flex; align-items: center; justify-content: space-between;
                        font-weight: 600; margin-bottom: 1rem; }
        .cr-menu-form { display: flex; flex-direction: column; gap: .75rem; }
        .cr-knob-label { display: block; font-size: .6875rem; letter-spacing: .05em; text-transform: uppercase;
                         color: var(--pk-muted); margin-bottom: .25rem; }
        .cr-menu-sep { margin: 1rem 0; }
        .cr-menu-actions { display: flex; flex-direction: column; gap: .5rem; }
        .cr-menu-actions > * { width: 100%; justify-content: center; }

        /* canvas masonry */
        .cr-canvas { columns: 3; column-gap: 1rem; padding: 1.5rem 1.5rem 5rem calc(200px + 4.5rem); }
        .cr-tile { break-inside: avoid; margin-bottom: 1rem; }
        @media (max-width: 1280px) { .cr-canvas { columns: 2; } }
        @media (max-width: 900px)  { .cr-canvas { columns: 1; padding-left: 1.5rem; } .cr-menu { position: static; width: auto; margin: 1.5rem; } }

        /* shared card internals */
        .cr-stack { display: flex; flex-direction: column; gap: 1rem; }
        .cr-field { display: flex; flex-direction: column; gap: .375rem; }
        .cr-between { display: flex; align-items: center; justify-content: space-between; gap: 1rem; }
        .cr-center { align-items: center; text-align: center; }
        .cr-center-text { margin: 0; }
        .cr-muted { color: var(--pk-muted); }
        .cr-muted-sm { color: var(--pk-muted); font-size: .8125rem; }
        .cr-muted-sm p, p.cr-muted-sm { margin: .125rem 0 0; }
        .cr-full { width: 100%; }
        .cr-amount { font-size: 1.25rem; }
        .cr-stat-row { display: grid; grid-template-columns: 1fr 1fr; gap: .75rem; margin-top: 1rem; }
        .cr-stat { display: flex; flex-direction: column; gap: .125rem; padding: .75rem;
                   background: var(--pk-surface-2, var(--pk-surface)); border-radius: calc(var(--pk-radius) - 2px); }
        .cr-stat-label { font-size: .6875rem; letter-spacing: .05em; text-transform: uppercase; color: var(--pk-muted); }
        .cr-stat-sub { font-size: .8125rem; color: var(--pk-muted); }
        .cr-target { display: flex; flex-direction: column; gap: .375rem; }
        .cr-target-amount { font-size: 1.5rem; letter-spacing: -.02em; }
        .cr-balance { font-size: 2.25rem; letter-spacing: -.03em; }
        .cr-ledger { display: flex; flex-direction: column; gap: .625rem; font-size: .875rem; }
        .cr-note { padding: .75rem; font-size: .8125rem; color: var(--pk-muted);
                   background: var(--pk-surface-2, var(--pk-surface)); border-radius: calc(var(--pk-radius) - 2px); }
        .cr-tx-icon { color: var(--pk-muted); }
        .cr-qr { width: 160px; height: 160px; color: var(--pk-text); }
        .cr-switch-row { display: flex; align-items: flex-start; justify-content: space-between; gap: 1rem; }
        .cr-switch-title { font-size: .875rem; }
        .cr-links-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; }
        .cr-links-group { display: flex; flex-direction: column; gap: .125rem; }
        .cr-links-group .cr-stat-label { margin-bottom: .375rem; }
        .cr-link-item { display: flex; align-items: center; gap: .5rem; padding: .375rem .5rem;
                        font-size: .875rem; color: var(--pk-text); text-decoration: none;
                        border-radius: calc(var(--pk-radius) - 2px); }
        .cr-link-item:hover { background: var(--pk-accent); }
        .cr-link-item.active { background: var(--pk-accent); font-weight: 600; }
        .cr-holding { display: flex; align-items: center; gap: .75rem; padding: .625rem .75rem;
                      border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) - 2px); }
        .cr-holding > div:first-child { flex: 1; display: flex; flex-direction: column; }
        .cr-holding-name { font-size: .875rem; }
        .cr-holding-amount { font-size: .9375rem; }
        .cr-spark { display: flex; align-items: flex-end; gap: 3px; height: 28px; }
        .cr-spark span { width: 7px; background: var(--pk-chart-1, var(--pk-text)); border-radius: 2px; opacity: .85; }
        .cr-donut { position: relative; max-width: 220px; margin: 0 auto 1rem; }
        .cr-donut-label { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center;
                          font-size: 1.5rem; font-weight: 700; letter-spacing: -.02em; pointer-events: none; }
        .cr-prose p { margin: 0; color: var(--pk-text-2, var(--pk-text)); }
        .cr-defined { text-decoration: underline dotted; text-underline-offset: 3px; cursor: help; }
        .cr-slider-row { display: flex; align-items: center; gap: .625rem; padding: .5rem .75rem;
                         border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) - 2px); }
        .cr-slider-row .cr-slider-label { font-size: .875rem; min-width: 5.5rem; }
        .cr-slider-row .pk-slider { flex: 1; }
        .cr-slider-row svg { color: var(--pk-muted); flex: none; }

        /* page dots */
        .cr-dots { position: fixed; right: 1.5rem; bottom: 1.5rem; z-index: 30; display: flex; gap: .25rem;
                   padding: .25rem; border: 1px solid var(--pk-border); border-radius: 999px;
                   background: var(--pk-surface); }
        .cr-dot { padding: .125rem .625rem; font-size: .75rem; border-radius: 999px; color: var(--pk-muted); }
        .cr-dot.active { background: var(--pk-brand); color: var(--pk-brand-ink); }
      CSS
    end
  end
end
