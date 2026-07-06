# frozen_string_literal: true

module Create
  # A PhlexKit recreation of ui.shadcn.com/create: a top navbar (with docs
  # navigation + ⌘K command palette), the Customizer sidebar (a kit Card of
  # picker rows — each a side-right DropdownMenu — whose knobs actually work:
  # ?theme= swaps the bundled theme stylesheet, ?icons= the icon library,
  # ?heading=/?font= the font tokens, ?chart= the --pk-chart palette, with
  # named ?preset= bundles), and TWO demo screens — 01 finance, 02 smart-home
  # + artist — each a fixed-width horizontally scrolling grid of top-aligned
  # card columns, switched by the floating 01/02 pill (?screen=). Every card
  # and control is built from kit components.
  class Page < Phlex::HTML
    include Phlex::Rails::Helpers::StylesheetLinkTag
    include Phlex::Rails::Helpers::JavaScriptImportmapTags
    include Phlex::Rails::Helpers::JavaScriptIncludeTag
    include Phlex::Rails::Helpers::AssetPath

    THEMES = %w[neutral zinc claude].freeze
    ICON_LIBRARIES = %w[lucide tabler phosphor remix].freeze

    # Font knobs swap CSS stacks only — no extra webfonts shipped. nil = the
    # page's bundled Geist.
    FONTS = {
      "serif" => %(Georgia, "Times New Roman", serif),
      "mono" => %("Geist Mono", ui-monospace, SFMono-Regular, monospace),
      "rounded" => %(ui-rounded, "SF Pro Rounded", system-ui, sans-serif)
    }.freeze
    FONT_LABELS = { nil => "Geist", "serif" => "Serif", "mono" => "Mono", "rounded" => "Rounded" }.freeze

    # --pk-chart-1..5 palettes; nil = the kit's default blues.
    CHART_PALETTES = {
      "emerald" => %w[#6ee7b7 #34d399 #10b981 #059669 #047857],
      "amber" => %w[#fcd34d #fbbf24 #f59e0b #d97706 #b45309],
      "violet" => %w[#c4b5fd #a78bfa #8b5cf6 #7c3aed #6d28d9],
      "rose" => %w[#fda4af #fb7185 #f43f5e #e11d48 #be123c]
    }.freeze

    # Named knob bundles — the shareable "--preset <code>" state.
    PRESETS = {
      "b0" => {},
      "c1" => { theme: "claude", heading: "serif", chart: "amber" },
      "z2" => { theme: "zinc", heading: "mono", font: "mono", chart: "violet", icons: "tabler" },
      "n3" => { theme: "neutral", heading: "rounded", chart: "emerald", icons: "phosphor" }
    }.freeze

    def initialize(theme: nil, icons: nil, heading: nil, font: nil, chart: nil, screen: nil)
      @theme = theme
      @icons = icons
      @heading = heading
      @font = font
      @chart = chart
      @screen = screen
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
          style { safe(knob_css) } unless knob_css.empty?
        end
        body do
          navbar
          menu_panel
          main(class: "cr-viewport", id: "cr-viewport") do
            div(class: "cr-canvas#{" two" if @screen == "2"}") do
              @screen == "2" ? screen_two : screen_one
            end
          end
          screen_pill
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

    def column(wide: false, &block)
      div(class: "cr-col#{" wide" if wide}", &block)
    end

    def duo(tight: false, &block)
      div(class: "cr-duo#{" tight" if tight}", &block)
    end

    # Current knobs merged with changes, as a /create URL (nil drops a param).
    def url_with(**changes)
      merged = { theme: @theme, icons: @icons, heading: @heading, font: @font,
                 chart: @chart, screen: @screen }.merge(changes).compact
      merged.empty? ? "/create" : "/create?#{merged.map { |k, v| "#{k}=#{v}" }.join("&")}"
    end

    # Rendered after page_css so these :root overrides win by order.
    def knob_css
      rules = []
      rules << ":root { --pk-font-sans: #{FONTS[@font]}; }" if FONTS[@font]
      rules << ":root { --cr-font-heading: #{FONTS[@heading]}; }" if FONTS[@heading]
      if (pal = CHART_PALETTES[@chart])
        vars = pal.each_with_index.map { |c, i| "--pk-chart-#{i + 1}: #{c};" }.join(" ")
        rules << ":root { #{vars} }"
      end
      rules.join("\n")
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
              render PhlexKit::NavigationMenuLink.new(href: "/examples") { "Examples" }
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
                render PhlexKit::CommandItem.new(value: "examples admin ui harbor", href: "/examples") { "Admin UI examples" }
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

    def get_code_dialog(full: false)
      render PhlexKit::Dialog.new do
        render PhlexKit::DialogTrigger.new(class: full ? "cr-full" : nil) do
          render PhlexKit::Button.new(size: :sm, class: full ? "cr-full" : nil) { "Get Code" }
        end
        render PhlexKit::DialogContent.new do
          render PhlexKit::DialogHeader.new do
            render PhlexKit::DialogTitle.new { "Install PhlexKit" }
            render PhlexKit::DialogDescription.new do
              plain "This look is the stock kit"
              plain @theme ? " with the bundled #{@theme} theme" : ""
              plain (@icons && @icons != "lucide") ? " and #{@icons} icons" : ""
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

    # The Customizer — like ui.shadcn.com/create's sidebar: a kit Card of
    # picker rows (each a side-right DropdownMenu with a label-over-value
    # trigger and a right-edge indicator), preset tools, and Get Code.
    def menu_panel
      aside(class: "cr-menu") do
        render PhlexKit::Card.new(class: "cr-customizer pk-dark") do
          render PhlexKit::CardHeader.new(class: "cr-cust-head") { main_menu }
          render PhlexKit::CardContent.new(class: "cr-cust-body") do
            picker_row(label: "Style", value: "PhlexKit", param: :style,
                       options: [ [ "PhlexKit", nil ] ]) { style_shape }
            cust_sep
            picker_row(label: "Base Color", value: "Neutral", param: :base,
                       options: [ [ "Neutral", nil ] ]) { color_dot("#a3a3a3") }
            picker_row(label: "Theme", value: (@theme || "default").capitalize, param: :theme,
                       options: [ [ "Default", nil ] ] + THEMES.map { |t| [ t.capitalize, t ] }) { color_dot(theme_dot_color) }
            picker_row(label: "Chart Color", value: (@chart || "blue").capitalize, param: :chart,
                       options: [ [ "Blue", nil ] ] + CHART_PALETTES.keys.map { |c| [ c.capitalize, c ] }) { color_dot(chart_dot_color) }
            cust_sep
            picker_row(label: "Heading", value: FONT_LABELS[@heading], param: :heading,
                       options: FONT_LABELS.map { |v, l| [ l, v ] }) { span(class: "cr-aa") { "Aa" } }
            picker_row(label: "Font", value: FONT_LABELS[@font], param: :font,
                       options: FONT_LABELS.map { |v, l| [ l, v ] }) { span(class: "cr-aa") { "Aa" } }
            cust_sep
            picker_row(label: "Icon Library", value: (@icons || "lucide").capitalize, param: :icons,
                       options: ICON_LIBRARIES.map { |l| [ l.capitalize, l == "lucide" ? nil : l ] }) { icon(:star, size: 15) }
          end
          render PhlexKit::CardFooter.new(class: "cr-cust-foot") do
            preset_copy_button
            open_preset_dialog
            render PhlexKit::Button.new(variant: :outline, size: :sm, class: "cr-full", onclick: safe(shuffle_js)) { "Shuffle" }
          end
          render PhlexKit::CardFooter.new(class: "cr-cust-foot cr-cust-cta") do
            get_code_dialog(full: true)
          end
        end
      end
    end

    # "Menu" header row — a dropdown like their MainMenu (Shuffle / Reset).
    def main_menu
      render PhlexKit::DropdownMenu.new(class: "cr-main-menu") do
        render PhlexKit::DropdownMenuTrigger.new do
          button(type: "button", class: "cr-main-menu-trigger") do
            span { "Menu" }
            icon(:menu, size: 16)
          end
        end
        render PhlexKit::DropdownMenuContent.new do
          render PhlexKit::DropdownMenuItem.new(as: :div, onclick: safe(shuffle_js)) { "Shuffle" }
          render PhlexKit::DropdownMenuItem.new(href: "/create") { "Reset" }
        end
      end
    end

    def cust_sep
      render PhlexKit::Separator.new(class: "cr-cust-sep")
    end

    # One sidebar row: muted label over the current value, indicator pinned to
    # the right edge; opens a side-right menu of options (check on current).
    def picker_row(label:, value:, param:, options:, &indicator)
      current = { theme: @theme, chart: @chart, heading: @heading, font: @font,
                  icons: @icons == "lucide" ? nil : @icons }[param]
      render PhlexKit::DropdownMenu.new(class: "cr-picker") do
        render PhlexKit::DropdownMenuTrigger.new do
          button(type: "button", class: "cr-picker-row") do
            span(class: "cr-picker-label") { label }
            span(class: "cr-picker-value") { value }
            span(class: "cr-picker-indicator", &indicator)
          end
        end
        render PhlexKit::DropdownMenuContent.new(side: :right, class: "cr-picker-menu") do
          options.each do |opt_label, opt_value|
            href = %i[style base].include?(param) ? url_with : url_with(param => opt_value)
            render PhlexKit::DropdownMenuItem.new(href: href) do
              span(class: "cr-picker-check#{" on" if opt_value == current}") { icon(:check, size: 14) }
              plain opt_label
            end
          end
        end
      end
    end

    def color_dot(color)
      span(class: "cr-dot-swatch", style: "background: #{color}")
    end

    def theme_dot_color
      { nil => "#3b82f6", "neutral" => "#a3a3a3", "zinc" => "#71717a", "claude" => "#d97757" }[@theme]
    end

    def chart_dot_color
      (CHART_PALETTES[@chart] || %w[x #3b82f6])[1]
    end

    # The rounded-square "style" indicator (their Nova shape).
    def style_shape
      svg(viewBox: "0 0 16 16", width: "14", height: "14", fill: "none") do |x|
        x.rect(x: 1.5, y: 1.5, width: 13, height: 13, rx: 4.5, stroke: "currentColor", "stroke-width": 1.5)
      end
    end

    # --- presets ---------------------------------------------------------------

    # The PRESETS entry matching the current knobs, else "custom".
    def current_preset_code
      knobs = { theme: @theme, icons: @icons, heading: @heading, font: @font, chart: @chart }.compact
      (PRESETS.find { |_, bundle| bundle == knobs } || [ "custom" ]).first
    end

    def preset_copy_button
      code = current_preset_code
      copy = "navigator.clipboard.writeText('--preset #{code}');"              "const b = this, t = b.textContent; b.textContent = 'Copied';"              "setTimeout(() => { b.textContent = t; }, 2000);"
      render PhlexKit::Button.new(variant: :outline, size: :sm, class: "cr-full cr-preset-code", onclick: safe(copy)) { "--preset #{code}" }
    end

    def open_preset_dialog
      render PhlexKit::Dialog.new do
        render PhlexKit::DialogTrigger.new(class: "cr-full") do
          render PhlexKit::Button.new(variant: :outline, size: :sm, class: "cr-full") { "Open Preset" }
        end
        render PhlexKit::DialogContent.new do
          render PhlexKit::DialogHeader.new do
            render PhlexKit::DialogTitle.new { "Open Preset" }
            render PhlexKit::DialogDescription.new { "Paste a preset code, or pick a curated one." }
          end
          render PhlexKit::DialogMiddle.new do
            form(action: "/create", method: "get", class: "cr-preset-form") do
              render PhlexKit::Input.new(name: "preset", placeholder: "b0")
              render PhlexKit::Button.new(size: :sm) { "Apply" }
            end
            div(class: "cr-preset-list") do
              PRESETS.each_key do |code|
                a(href: "/create?preset=#{code}", class: "pk-button outline sm") { "--preset #{code}" }
              end
            end
          end
        end
      end
    end

    def shuffle_js
      picks = {
        theme: [ "" ] + THEMES,
        icons: ICON_LIBRARIES,
        heading: [ "" ] + FONTS.keys,
        font: [ "" ] + FONTS.keys,
        chart: [ "" ] + CHART_PALETTES.keys
      }
      js = +"const p = new URLSearchParams(); const pick = (a) => a[Math.floor(Math.random() * a.length)];"
      picks.each { |k, vals| js << "{ const v = pick(#{vals}.map(String)); if (v) p.set('#{k}', v); }" }
      js << "location.href = '/create' + (p.size ? '?' + p.toString() : '');"
      js
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
        [ :heart, "Blue Bottle Coffee", "Food & Drink", "Today, 10:24 AM", "-$6.50", false ],
        [ :shopping_cart, "Whole Foods Market", "Groceries", "Yesterday", "-$142.30", false ],
        [ :credit_card, "Stripe Payout", "Income", "Oct 12", "+$4,200.00", true ],
        [ :map_pin, "Uber Technologies", "Transport", "Oct 11", "-$24.10", false ],
        [ :play, "Netflix Subscription", "Entertainment", "Oct 10", "-$19.99", false ]
      ]
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Recent Transactions" }
          render PhlexKit::CardDescription.new { "Your latest account activity." }
          render PhlexKit::CardAction.new do
            render PhlexKit::Button.new(variant: :outline, size: :sm) { "View All" }
          end
        end
        render PhlexKit::CardContent.new do
          render PhlexKit::Table.new(class: "cr-tx-table") do
            render PhlexKit::TableBody.new do
              transactions.each do |glyph, title, category, date, amount, income|
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableCell.new do
                    div(class: "cr-tx-name") do
                      span(class: "cr-tx-icon") { icon(glyph) }
                      div do
                        strong { title }
                        span(class: "cr-muted-sm") { category }
                      end
                    end
                  end
                  render PhlexKit::TableCell.new(class: "cr-muted") { date }
                  render PhlexKit::TableCell.new(class: "cr-tx-amount#{" income" if income}") { amount }
                  render PhlexKit::TableCell.new(class: "cr-tx-menu") do
                    render PhlexKit::Button.new(variant: :ghost, size: :sm, icon: true, aria: { label: "Transaction menu" }) { icon(:ellipsis, size: 14) }
                  end
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

    def buy_investment_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Buy Investment" }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Amount to Invest" }
            render PhlexKit::InputGroup.new do
              render PhlexKit::InputGroupAddon.new { "$" }
              render PhlexKit::Input.new(name: "invest_amount", value: "1,000.00")
            end
          end
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Order Type" }
            render PhlexKit::NativeSelect.new(name: "order_type") do
              render PhlexKit::NativeSelectOption.new(value: "market", selected: true) { "Market Order" }
              render PhlexKit::NativeSelectOption.new(value: "limit") { "Limit Order" }
            end
            span(class: "cr-muted-sm") { "Market orders execute at the current price." }
          end
          render PhlexKit::Separator.new
          div(class: "cr-ledger") do
            div(class: "cr-between") do
              span(class: "cr-muted") { "Estimated Shares" }
              strong { "1.95" }
            end
            div(class: "cr-between") do
              span(class: "cr-muted") { "Buying Power" }
              strong { "$12,450.00" }
            end
          end
        end
        render PhlexKit::CardFooter.new(class: "cr-stack-sm") do
          render PhlexKit::Button.new(class: "cr-full") { "Review Order" }
          p(class: "cr-muted-sm cr-center-text") { "Trades are typically executed within minutes during market hours." }
        end
      end
    end

    def payments_menu_card
      entries = [
        [ :refresh, "Change transfer limit", "Adjust how much you can send from your balance." ],
        [ :calendar, "Scheduled transfers", "Set up a transfer to send at a later date." ],
        [ :credit_card, "Direct Debits", "Set up and manage regular payments." ],
        [ :refresh, "Recurring card payments", "Manage your repeated card transactions." ]
      ]
      render PhlexKit::Card.new do
        render PhlexKit::CardContent.new(class: "cr-stack") do
          render PhlexKit::Breadcrumb.new do
            render PhlexKit::BreadcrumbList.new do
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbLink.new(href: "#") { "Home" }
              end
              render PhlexKit::BreadcrumbSeparator.new
              render PhlexKit::BreadcrumbItem.new do
                render PhlexKit::BreadcrumbEllipsis.new
              end
              render PhlexKit::BreadcrumbSeparator.new
              render PhlexKit::BreadcrumbItem.new { "Payments" }
            end
          end
          render PhlexKit::ItemGroup.new do
            entries.each do |glyph, title, description|
              render PhlexKit::Item.new(variant: :muted) do
                render PhlexKit::ItemMedia.new(class: "cr-tx-icon") { icon(glyph) }
                render PhlexKit::ItemContent.new do
                  render PhlexKit::ItemTitle.new { title }
                  render PhlexKit::ItemDescription.new { description }
                end
                render PhlexKit::ItemActions.new { icon(:chevron_right, size: 14) }
              end
            end
          end
        end
      end
    end

    def front_door_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Front Door" }
          render PhlexKit::CardDescription.new { "Smart Lock Pro" }
          render PhlexKit::CardAction.new(class: "cr-lock-state") do
            span { "Locked" }
            icon(:lock, size: 14)
          end
        end
        render PhlexKit::CardContent.new do
          div(class: "cr-camera") do
            span(class: "cr-live") { "Live" }
          end
        end
      end
    end

    def account_access_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Account Access" }
          render PhlexKit::CardDescription.new { "Update your credentials or re-authenticate." }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Email Address" }
            render PhlexKit::Input.new(type: "email", name: "email", value: "artist@studio.inc")
          end
          div(class: "cr-field") do
            div(class: "cr-between") do
              render PhlexKit::Label.new { "Current Password" }
              a(href: "#", class: "cr-forgot") { "Forgot?" }
            end
            render PhlexKit::Input.new(type: "password", name: "current_password", value: "hunter2hunter")
          end
          render PhlexKit::Button.new(class: "cr-full") do
            icon(:lock, size: 14)
            plain " Update Security"
          end
          render PhlexKit::Item.new(variant: :muted) do
            render PhlexKit::ItemMedia.new(class: "cr-danger") { icon(:circle_alert) }
            render PhlexKit::ItemContent.new do
              render PhlexKit::ItemTitle.new { "Danger Zone" }
              render PhlexKit::ItemDescription.new { "Archive account and remove catalog" }
            end
            render PhlexKit::ItemActions.new { icon(:arrow_right, size: 14) }
          end
        end
      end
    end

    def card_balance_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardDescription.new { "Card Balance" }
          render PhlexKit::CardTitle.new(class: "cr-amount") { "US$12.94" }
        end
        render PhlexKit::CardContent.new do
          span(class: "cr-muted-sm") { "US$11,337.06 Available" }
        end
      end
    end

    def payment_due_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardDescription.new { "Payment Due" }
          render PhlexKit::CardTitle.new(class: "cr-amount") { "1 Apr" }
        end
        render PhlexKit::CardContent.new do
          render PhlexKit::Button.new(variant: :outline, size: :sm, class: "cr-full") { "Pay Early" }
        end
      end
    end

    def yearly_activity_card
      months = [ 35, 55, 30, 70, 45, 60, 80, 40, 55, 75, 45, 90 ]
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Yearly Activity" }
          render PhlexKit::CardAction.new do
            render PhlexKit::Badge.new(variant: :secondary) { "+US$0.25 Daily Cash" }
          end
        end
        render PhlexKit::CardContent.new do
          div(class: "cr-months") do
            months.each_with_index do |h, i|
              div(class: "cr-month") do
                span(class: "cr-month-bar", style: "height: #{h}%")
                span(class: "cr-month-label") { "JFMAMJJASOND"[i] }
              end
            end
          end
        end
      end
    end

    def transfer_funds_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Transfer Funds" }
          render PhlexKit::CardDescription.new { "Move money between your connected accounts." }
          render PhlexKit::CardAction.new do
            render PhlexKit::Button.new(variant: :ghost, size: :sm, icon: true, aria: { label: "Dismiss" }) { icon(:x, size: 14) }
          end
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Amount to Transfer" }
            render PhlexKit::InputGroup.new do
              render PhlexKit::InputGroupAddon.new { "$" }
              render PhlexKit::Input.new(name: "transfer_amount", value: "1,200.00")
            end
          end
          div(class: "cr-field") do
            render PhlexKit::Label.new { "From Account" }
            render PhlexKit::NativeSelect.new(name: "from_account") do
              render PhlexKit::NativeSelectOption.new(value: "checking", selected: true) { "Main Checking (··8402) — $12,450.00" }
              render PhlexKit::NativeSelectOption.new(value: "savings") { "High Yield Savings (··1192) — $42,100.00" }
            end
          end
          div(class: "cr-field") do
            render PhlexKit::Label.new { "To Account" }
            render PhlexKit::NativeSelect.new(name: "to_account") do
              render PhlexKit::NativeSelectOption.new(value: "savings", selected: true) { "High Yield Savings (··1192) — $42,100.00" }
              render PhlexKit::NativeSelectOption.new(value: "checking") { "Main Checking (··8402) — $12,450.00" }
            end
          end
          div(class: "cr-ledger") do
            div(class: "cr-between") do
              span(class: "cr-muted") { "Estimated arrival" }
              strong { "Today, Apr 14" }
            end
            render PhlexKit::Separator.new
            div(class: "cr-between") do
              span(class: "cr-muted") { "Transaction fee" }
              span { "$0.00" }
            end
            render PhlexKit::Separator.new
            div(class: "cr-between") do
              span(class: "cr-muted") { "Total amount" }
              strong { "$1,200.00" }
            end
          end
        end
        render PhlexKit::CardFooter.new do
          render PhlexKit::Button.new(class: "cr-full") { "Confirm Transfer" }
        end
      end
    end

    def connect_bank_card
      render PhlexKit::Card.new do
        render PhlexKit::CardContent.new do
          render PhlexKit::Empty.new do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyMedia.new { icon(:credit_card, size: 20) }
              render PhlexKit::EmptyTitle.new { "Connect Bank" }
              render PhlexKit::EmptyDescription.new { "Link your payout method to receive monthly royalty distributions automatically." }
            end
            render PhlexKit::EmptyContent.new do
              render PhlexKit::Button.new { "Set Up Payouts" }
            end
          end
        end
      end
    end

    def receiving_method_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardDescription.new { "Payout Preferences" }
          render PhlexKit::CardTitle.new { "Receiving Method" }
          render PhlexKit::CardAction.new do
            render PhlexKit::Button.new(variant: :ghost, size: :sm, icon: true, aria: { label: "Dismiss" }) { icon(:x, size: 14) }
          end
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Account Holder Name" }
            render PhlexKit::Input.new(name: "account_holder", value: "Synthetic Horizons Music LLC")
          end
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Receiving Method" }
            render PhlexKit::RadioGroup.new(class: "cr-method-tiles") do
              label(class: "cr-method-tile") do
                render PhlexKit::RadioButton.new(name: "receiving_method", value: "bank", checked: true)
                div do
                  strong { "Bank Transfer" }
                  span(class: "cr-muted-sm") { "SWIFT / IBAN" }
                end
              end
              label(class: "cr-method-tile") do
                render PhlexKit::RadioButton.new(name: "receiving_method", value: "paypal")
                div do
                  strong { "PayPal" }
                  span(class: "cr-muted-sm") { "Instant Payout" }
                end
              end
            end
          end
          div(class: "cr-field") do
            render PhlexKit::Label.new { "IBAN / Account Number" }
            render PhlexKit::Input.new(name: "iban", placeholder: "DE89 3704 0044 ....")
          end
        end
        render PhlexKit::CardFooter.new do
          render PhlexKit::Button.new(variant: :secondary, class: "cr-full", disabled: true) { "Save Payout Settings" }
        end
      end
    end

    def power_usage_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Power Usage" }
          render PhlexKit::CardDescription.new { "Whole Home" }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          render PhlexKit::Chart.new(options: {
            type: "bar",
            data: {
              labels: %w[6a 8a 10a 12p 2p 4p 6p 8p],
              datasets: [ { label: "kW", data: [ 1.2, 2.8, 2.6, 2.1, 3.1, 2.4, 3.4, 2.9 ], borderWidth: 0, borderRadius: 4 } ]
            },
            options: { plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } }, y: { display: false } } }
          })
          div(class: "cr-stat-row") do
            div(class: "cr-stat") do
              span(class: "cr-stat-label") { "Currently Using" }
              strong { "3.4 kW" }
            end
            div(class: "cr-stat") do
              span(class: "cr-stat-label") { "Solar Gen" }
              strong(class: "cr-muted") { "+1.2 kW" }
            end
          end
          render PhlexKit::Separator.new
          div(class: "cr-between") do
            span(class: "cr-muted-sm") { "Battery Level" }
            span(class: "cr-muted-sm") { "85%" }
          end
          render PhlexKit::Progress.new(value: 85)
        end
      end
    end

    def upcoming_payments_card
      payments = [
        [ "Netflix Subscription", "Apr 15, 2024", "$19.99" ],
        [ "Rent Payment", "Apr 1, 2024", "$2,400.00" ],
        [ "Auto Insurance", "Apr 22, 2024", "$186.00" ]
      ]
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Upcoming Payments" }
          render PhlexKit::CardDescription.new { "Select a date to view scheduled payments." }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          render PhlexKit::Calendar.new(selected_date: Date.new(2026, 7, 4))
          render PhlexKit::ItemGroup.new do
            payments.each do |title, date, amount|
              render PhlexKit::Item.new(variant: :muted) do
                render PhlexKit::ItemContent.new do
                  render PhlexKit::ItemTitle.new { title }
                  render PhlexKit::ItemDescription.new { date }
                end
                render PhlexKit::ItemActions.new { strong(class: "cr-payment-amount") { amount } }
              end
            end
          end
        end
      end
    end

    def living_room_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Living Room" }
          render PhlexKit::CardDescription.new { "Roller Shades" }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-shade") { div(class: "cr-shade-blind") }
          div(class: "cr-slider-row cr-shade-slider") do
            span(class: "cr-stat-label") { "Open" }
            render PhlexKit::Slider.new(name: "shade_position", value: 50)
            span(class: "cr-stat-label") { "Close" }
          end
        end
        render PhlexKit::CardFooter.new(class: "cr-trio") do
          render PhlexKit::Button.new(variant: :outline, size: :sm) { "Open" }
          render PhlexKit::Button.new(variant: :secondary, size: :sm) { "Half" }
          render PhlexKit::Button.new(variant: :outline, size: :sm) { "Closed" }
        end
      end
    end

    def stock_performance_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Stock Performance" }
          render PhlexKit::CardDescription.new { "6-month price history." }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Ticker" }
            render PhlexKit::NativeSelect.new(name: "ticker") do
              render PhlexKit::NativeSelectOption.new(value: "voo", selected: true) { "VOO" }
              render PhlexKit::NativeSelectOption.new(value: "vig") { "VIG" }
              render PhlexKit::NativeSelectOption.new(value: "aapl") { "AAPL" }
            end
          end
          render PhlexKit::Chart.new(options: {
            type: "line",
            data: {
              labels: %w[Nov Dec Jan Feb Mar Apr],
              datasets: [ { label: "VOO", data: [ 412, 428, 419, 445, 452, 471 ], borderWidth: 2, pointRadius: 0, tension: 0.4, fill: false } ]
            },
            options: { plugins: { legend: { display: false } }, scales: { x: { display: false }, y: { display: false } } }
          })
        end
      end
    end

    def explore_catalog_card
      render PhlexKit::Card.new do
        render PhlexKit::CardContent.new do
          render PhlexKit::Empty.new do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyMedia.new { icon(:mic, size: 20) }
              render PhlexKit::EmptyTitle.new { "Explore Catalog" }
              render PhlexKit::EmptyDescription.new { "Check your ISRC codes, metadata, and visual assets before going live." }
            end
            render PhlexKit::EmptyContent.new do
              render PhlexKit::Button.new { "View Catalog" }
            end
          end
        end
      end
    end

    def set_milestone_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Set a new milestone" }
          render PhlexKit::CardDescription.new { "Define your financial target and we'll help you pace your savings." }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-field") do
            render PhlexKit::Label.new { "Goal Name" }
            render PhlexKit::Input.new(name: "goal_name", placeholder: "e.g. New Car, Home Downpayment")
          end
          div(class: "cr-duo tight") do
            div(class: "cr-field") do
              render PhlexKit::Label.new { "Target Amount" }
              render PhlexKit::Input.new(name: "target_amount", value: "$15,000")
            end
            div(class: "cr-field") do
              render PhlexKit::Label.new { "Target Date" }
              render PhlexKit::Input.new(name: "target_date", value: "Dec 2025")
            end
          end
        end
        render PhlexKit::CardFooter.new(class: "cr-stack-sm") do
          render PhlexKit::Button.new(class: "cr-full") { "Create Goal" }
          render PhlexKit::Button.new(variant: :outline, class: "cr-full") { "Cancel" }
        end
      end
    end

    def social_links_card
      links = [
        [ "Spotify Artist URL", :link, "spotify.com/artist/3j...2k", nil ],
        [ "Instagram Handle", :camera, "@julianduryea_music", nil ],
        [ "SoundCloud URL", :cloud, nil, "soundcloud.com/username" ],
        [ "Website", :globe, nil, "https://yoursite.com" ]
      ]
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Social Links" }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          links.each do |label, glyph, value, placeholder|
            div(class: "cr-field") do
              render PhlexKit::Label.new { label }
              render PhlexKit::InputGroup.new do
                render PhlexKit::InputGroupAddon.new { icon(glyph, size: 14) }
                render PhlexKit::Input.new(name: label.parameterize(separator: "_"), value: value, placeholder: placeholder)
              end
            end
          end
        end
        render PhlexKit::CardFooter.new(class: "cr-footer-end") do
          render PhlexKit::Button.new(variant: :ghost, size: :sm) { "Discard" }
          render PhlexKit::Button.new(size: :sm) { "Save Changes" }
        end
      end
    end

    def cover_art_card
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardDescription.new(class: "cr-stat-label") { "Cover Art" }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          div(class: "cr-dropzone") { icon(:image, size: 24) }
          render PhlexKit::Button.new(variant: :secondary, class: "cr-full") { "Upload Artwork" }
          p(class: "cr-muted-sm cr-center-text") { "Minimum 3000 × 3000px — JPEG or PNG only" }
        end
      end
    end

    def notifications_card
      alerts = [
        [ "Transaction alerts", "Deposits, withdrawals, and transfers.", true ],
        [ "Security alerts", "Login attempts and account changes.", true ],
        [ "Goal milestones", "Updates at 25%, 50%, 75%, and 100%.", false ],
        [ "Market updates", "Daily portfolio summary and price alerts.", false ]
      ]
      render PhlexKit::Card.new do
        render PhlexKit::CardHeader.new do
          render PhlexKit::CardTitle.new { "Notifications" }
          render PhlexKit::CardDescription.new { "Choose what you want to be notified about." }
        end
        render PhlexKit::CardContent.new(class: "cr-stack") do
          label(class: "cr-check-row") do
            render PhlexKit::Checkbox.new(name: "select_all")
            div { strong(class: "cr-switch-title") { "Select all" } }
          end
          alerts.each do |title, description, checked|
            label(class: "cr-check-row") do
              render PhlexKit::Checkbox.new(name: title.parameterize(separator: "_"), checked: checked)
              div do
                strong(class: "cr-switch-title") { title }
                p(class: "cr-muted-sm") { description }
              end
            end
          end
        end
        render PhlexKit::CardFooter.new do
          render PhlexKit::Button.new(class: "cr-full") { "Save Preferences" }
        end
      end
    end

    # --- screens + switcher ---------------------------------------------------

    # Screen 01 — the finance dashboard.
    def screen_one
      column do
        contribution_history_card
        dividend_income_card
        dollar_cost_card
        syncing_card
      end
      column do
        payout_threshold_card
        claimable_balance_card
        preferences_card
        savings_goal_card
      end
      column(wide: true) do
        duo do
          savings_targets_card
          buy_investment_card
        end
        recent_transactions_card
        duo do
          quick_links_card
          payments_menu_card
        end
        duo do
          faq_card
          holdings_search_card
        end
      end
      column do
        account_access_card
        duo(tight: true) do
          card_balance_card
          payment_due_card
        end
        yearly_activity_card
        transfer_funds_card
        connect_bank_card
      end
      column do
        receiving_method_card
        upcoming_payments_card
        set_milestone_card
      end
      column do
        stock_performance_card
        notifications_card
      end
    end

    # Screen 02 — smart home + artist tools.
    def screen_two
      column do
        kitchen_island_card
        front_door_card
      end
      column do
        living_room_card
        power_usage_card
      end
      column do
        distribute_track_card
        qr_connect_card
        explore_catalog_card
      end
      column do
        cover_art_card
        social_links_card
      end
    end

    # Like ui.shadcn.com/create's preview switcher: a floating pill of two
    # ghost buttons at the canvas's bottom-right, swapping between the two
    # demo screens (a URL param — the other knobs survive the switch).
    def screen_pill
      div(class: "cr-dots pk-dark") do
        a(href: url_with(screen: nil), class: "cr-dot#{" active" unless @screen == "2"}") { "01" }
        a(href: url_with(screen: "2"), class: "cr-dot#{" active" if @screen == "2"}") { "02" }
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
        /* app shell: the page never scrolls — the canvas pans inside <main> */
        body { margin: 0; height: 100dvh; display: flex; flex-direction: column; overflow: hidden;
               background: var(--pk-bg); color: var(--pk-text); font: 15px/1.5 var(--pk-font-sans); }
        /* the Heading knob sets --cr-font-heading (knob_css) */
        h1, h2, h3, h4 { font-family: var(--cr-font-heading, inherit); }

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

        /* the Customizer — shadcn-create's sidebar card grammar */
        .cr-menu { position: fixed; left: 1.5rem; top: 4.5rem; bottom: 1.5rem; z-index: 30; width: 208px;
                   display: flex; align-items: flex-start; }
        .cr-customizer { width: 100%; max-height: 100%; display: flex; flex-direction: column;
                         gap: 0; padding: 0; /* the kit card's 16px gap/padding would band the sections apart */
                         border-radius: 1rem; overflow: hidden;
                         background: color-mix(in oklab, var(--pk-surface) 92%, transparent);
                         backdrop-filter: blur(12px); box-shadow: none; }
        .cr-cust-head { padding: .625rem .75rem; border-bottom: 1px solid var(--pk-border); }
        .cr-main-menu, .cr-picker { display: block; width: 100%; }
        .cr-main-menu .pk-dropdown-menu-trigger, .cr-picker .pk-dropdown-menu-trigger { display: block; width: 100%; }
        .cr-main-menu-trigger { display: flex; align-items: center; justify-content: space-between; width: 100%;
                                padding: .375rem .5rem; font: inherit; font-weight: 600; color: var(--pk-text);
                                background: none; border: none; cursor: pointer;
                                border-radius: calc(var(--pk-radius) - 2px);
                                box-shadow: 0 0 0 1px color-mix(in oklab, var(--pk-text) 10%, transparent); }
        .cr-main-menu-trigger:hover { background: var(--pk-accent); }
        .cr-cust-body { display: flex; flex-direction: column; gap: .625rem; padding: .75rem;
                        overflow-y: auto; min-height: 0; }
        /* full-bleed section dividers: the kit sets .pk-separator.horizontal
           { width: 100% } (0,2,0), so the override must out-specify it,
           and bleeding needs the width extended, not just negative margins */
        .cr-cust-body .pk-separator.cr-cust-sep { margin: .125rem -.75rem; width: calc(100% + 1.5rem); }
        .cr-picker-row { position: relative; display: flex; flex-direction: column; align-items: flex-start;
                         gap: .125rem; width: 100%; padding: .5rem 2.25rem .5rem .625rem; text-align: left;
                         font: inherit; color: var(--pk-text); background: none; border: none; cursor: pointer;
                         border-radius: calc(var(--pk-radius) - 2px);
                         box-shadow: 0 0 0 1px color-mix(in oklab, var(--pk-text) 10%, transparent); }
        .cr-picker-row:hover { background: var(--pk-accent); }
        .cr-picker-label { font-size: .75rem; color: var(--pk-muted); }
        .cr-picker-value { font-size: .875rem; font-weight: 500; }
        .cr-picker-indicator { position: absolute; right: .625rem; top: 50%; transform: translateY(-50%);
                               display: inline-flex; align-items: center; justify-content: center;
                               width: 1rem; height: 1rem; color: var(--pk-muted); }
        .cr-dot-swatch { width: .875rem; height: .875rem; border-radius: 999px; display: inline-block; }
        .cr-aa { font-size: .8125rem; font-weight: 600; }
        .cr-picker-menu .pk-dropdown-menu-viewport { min-width: 11rem; }
        .cr-picker-check { display: inline-flex; width: 1rem; visibility: hidden; }
        .cr-picker-check.on { visibility: visible; }
        .cr-cust-foot { display: flex; flex-direction: column; gap: .5rem; padding: .75rem;
                        border-top: 1px solid var(--pk-border); }
        .cr-cust-foot > *, .cr-cust-foot .pk-dialog-trigger { width: 100%; }
        .cr-cust-foot .pk-button { width: 100%; justify-content: center; }
        .cr-preset-code { font-family: var(--pk-font-mono); }
        .cr-preset-form { display: flex; gap: .5rem; }
        .cr-preset-form .pk-input { flex: 1; }
        .cr-preset-list { display: flex; flex-wrap: wrap; gap: .5rem; margin-top: .75rem; }
        .cr-preset-list .pk-button { font-family: var(--pk-font-mono); }

        /* canvas — fixed-width horizontal scroller of top-aligned columns,
           like ui.shadcn.com/create (7 tracks, one column spans two). The
           scroller is an inset, rounded, muted container sitting to the right
           of the menu — cards clip at its edge rather than scrolling under
           the menu panel. */
        /* position:relative so absolutely-positioned descendants without a
           positioned ancestor (e.g. sr-only live regions) resolve against the
           scroller, not the document — otherwise they leak page-level
           horizontal overflow. */
        .cr-viewport { position: relative; overflow: auto; flex: 1; min-height: 0;
                       margin: 1.5rem 1.5rem 1.5rem calc(208px + 4.5rem);
                       border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) + 8px);
                       background: var(--pk-surface-2); }
        html[data-theme="dark"] .cr-viewport { background: var(--pk-bg); }
        .cr-canvas { display: grid; grid-template-columns: repeat(7, 383px); gap: 2.5rem;
                     align-items: start; width: max-content; padding: 2.5rem; }
        .cr-canvas.two { grid-template-columns: repeat(4, 383px); }
        .cr-col { display: flex; flex-direction: column; gap: 2.5rem; min-width: 0; }
        .cr-col.wide { grid-column: span 2; }
        .cr-duo { display: grid; grid-template-columns: 1fr 1fr; gap: 2.5rem; align-items: start; }
        .cr-duo.tight { gap: 1rem; }
        @media (max-width: 900px) { body { height: auto; display: block; overflow: auto; }
                                    .cr-canvas { grid-template-columns: repeat(7, 300px); }
                                    .cr-viewport { margin: 1.5rem; }
                                    .cr-menu { position: static; width: auto; margin: 1.5rem; display: block; } }

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

        /* new-card internals */
        .cr-stack-sm { display: flex; flex-direction: column; gap: .5rem; }
        .cr-tx-table td { vertical-align: middle; }
        .cr-tx-name { display: flex; align-items: center; gap: .625rem; }
        .cr-tx-name > div { display: flex; flex-direction: column; }
        .cr-tx-name strong { font-size: .875rem; }
        .cr-tx-amount { text-align: right; font-weight: 600; white-space: nowrap; }
        .cr-tx-amount.income { color: var(--pk-green); }
        .cr-tx-menu { width: 1%; text-align: right; }
        .cr-forgot { font-size: .6875rem; letter-spacing: .05em; text-transform: uppercase;
                     color: var(--pk-muted); text-decoration: none; }
        .cr-forgot:hover { color: var(--pk-text); }
        .cr-danger { color: var(--pk-red, #dc2626); }
        .cr-lock-state { display: flex; align-items: center; gap: .375rem; font-size: .8125rem; color: var(--pk-muted); }
        .cr-camera { position: relative; height: 180px; border-radius: calc(var(--pk-radius) - 2px);
                     border: 1px solid var(--pk-border);
                     background: repeating-linear-gradient(45deg, transparent, transparent 6px,
                                 color-mix(in oklab, var(--pk-muted) 12%, transparent) 6px,
                                 color-mix(in oklab, var(--pk-muted) 12%, transparent) 7px); }
        .cr-live { position: absolute; top: .625rem; right: .625rem; padding: .125rem .5rem;
                   font-size: .75rem; font-weight: 600; border-radius: 999px;
                   color: var(--pk-red, #dc2626);
                   background: color-mix(in oklab, var(--pk-red, #dc2626) 12%, transparent); }
        .cr-months { display: flex; align-items: flex-end; gap: 4px; height: 72px; }
        .cr-month { flex: 1; display: flex; flex-direction: column; align-items: center; gap: .25rem;
                    height: 100%; justify-content: flex-end; }
        .cr-month-bar { width: 100%; background: var(--pk-chart-1, var(--pk-text)); border-radius: 3px; opacity: .85; }
        .cr-month-label { font-size: .625rem; color: var(--pk-muted); }
        .cr-method-tiles { display: grid; grid-template-columns: 1fr 1fr; gap: .625rem; }
        .cr-method-tile { display: flex; align-items: flex-start; gap: .5rem; padding: .625rem .75rem;
                          border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) - 2px);
                          cursor: pointer; }
        .cr-method-tile:has(:checked) { border-color: var(--pk-ring); background: var(--pk-accent); }
        .cr-method-tile > div { display: flex; flex-direction: column; }
        .cr-method-tile strong { font-size: .8125rem; }
        .cr-payment-amount { font-size: .875rem; white-space: nowrap; }
        .cr-shade { height: 120px; border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) - 2px);
                    background: var(--pk-surface-2, var(--pk-surface)); overflow: hidden; }
        .cr-shade-blind { height: 50%; background: color-mix(in oklab, var(--pk-muted) 55%, transparent); }
        .cr-shade-slider { border: none; padding: 0; }
        .cr-trio { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: .5rem; }
        .cr-trio > * { width: 100%; justify-content: center; }
        .cr-footer-end { display: flex; justify-content: flex-end; gap: .5rem; }
        .cr-dropzone { display: flex; align-items: center; justify-content: center; height: 180px;
                       border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) - 2px);
                       color: var(--pk-muted); }
        .cr-check-row { display: flex; align-items: flex-start; gap: .625rem; cursor: pointer; }
        .cr-check-row .pk-checkbox { margin-top: .125rem; }

        /* screen switcher pill — their preview-switcher grammar */
        .cr-dots { position: fixed; right: 2rem; bottom: 2rem; z-index: 30; display: flex; gap: .125rem;
                   padding: .25rem; border-radius: .75rem;
                   background: color-mix(in oklab, var(--pk-surface) 90%, transparent);
                   backdrop-filter: blur(12px); box-shadow: 0 8px 30px rgb(0 0 0 / .35); }
        .cr-dot { display: inline-flex; align-items: center; justify-content: center;
                  min-width: 2rem; height: 1.75rem; padding: 0 .625rem; font-size: .75rem; font-weight: 500;
                  border-radius: .5rem; color: var(--pk-muted); text-decoration: none; }
        .cr-dot:hover { background: var(--pk-accent); color: var(--pk-text); }
        .cr-dot.active { background: var(--pk-accent); color: var(--pk-text); }
      CSS
    end
  end
end
