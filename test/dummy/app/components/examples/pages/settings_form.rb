# frozen_string_literal: true

module Examples
  module Pages
    # 06 settings-form — Harbor's Settings: a sticky section rail beside
    # stacked FieldGroup sections (shell-rail; rail unsticks ≤768px) with a
    # sticky save bar.
    class SettingsForm < BasePage
      SECTIONS = [
        [ "general", "General", true ], [ "payments", "Payments", false ],
        [ "notifications", "Notifications", false ], [ "team", "Team", false ]
      ].freeze

      private

      def page_title = "Settings"

      def body_content
        div(class: "adm-rail") do
          harbor_topbar do
            span(class: "adm-topbar-crumb adm-muted") { "Settings" }
            div(class: "adm-topbar-spacer")
          end

          nav(class: "adm-rail-nav") do
            div(class: "adm-rail-nav-inner") do
              SECTIONS.each do |anchor, label, active|
                a(href: "##{anchor}", class: [ "adm-nav-link", ("active" if active) ].compact.join(" ")) { label }
              end
            end
          end

          main(class: "adm-rail-main adm-main adm-settings") do
            render PhlexKit::FieldGroup.new do
              general_section
              render PhlexKit::FieldSeparator.new
              payments_section
              render PhlexKit::FieldSeparator.new
              notifications_section
              render PhlexKit::FieldSeparator.new
              team_section
            end
            div(class: "adm-save-bar") do
              span(class: "adm-muted") { "Unsaved changes" }
              render PhlexKit::Button.new(
                variant: :ghost, size: :sm,
                onclick: safe("PhlexKit.toast.info('Changes discarded', { description: 'Settings reverted to the last save.' })")
              ) { "Discard" }
              render PhlexKit::Button.new(
                size: :sm,
                onclick: safe("PhlexKit.toast.success('Settings saved', { description: 'Changes apply to all Harbor channels.' })")
              ) { "Save changes" }
            end
          end

          harbor_footer "Changes apply to all Harbor channels · Harbor v2.4"
          scroll_spy_script
        end
      end

      # Highlights the rail link for the section nearest the top of the
      # viewport — page chrome, not a kit behavior.
      def scroll_spy_script
        script do
          safe(<<~JS)
            (() => {
              const links = [...document.querySelectorAll(".adm-rail-nav-inner a[href^='#']")];
              const byId = Object.fromEntries(links.map(l => [l.getAttribute("href").slice(1), l]));
              const spied = links.map(l => document.getElementById(l.getAttribute("href").slice(1))).filter(Boolean);
              const activate = (el) => {
                links.forEach(l => l.classList.remove("active"));
                byId[el.id]?.classList.add("active");
              };
              const atBottom = () => window.innerHeight + window.scrollY >= document.body.scrollHeight - 4;
              const visible = new Set();
              const spy = new IntersectionObserver((entries) => {
                entries.forEach(e => e.isIntersecting ? visible.add(e.target) : visible.delete(e.target));
                if (atBottom()) return activate(spied[spied.length - 1]);
                const top = [...visible].sort((a, b) => a.getBoundingClientRect().top - b.getBoundingClientRect().top)[0];
                if (top) activate(top);
              }, { rootMargin: "-15% 0px -55% 0px" });
              spied.forEach(el => spy.observe(el));
              /* the last section can never reach the band at max scroll */
              addEventListener("scroll", () => { if (atBottom()) activate(spied[spied.length - 1]); }, { passive: true });
            })();
          JS
        end
      end

      def general_section
        render PhlexKit::FieldSet.new(id: "general") do
          render PhlexKit::FieldLegend.new { "General" }
          render PhlexKit::FieldDescription.new { "How your store appears on receipts and invoices." }
          render PhlexKit::FieldGroup.new do
            render PhlexKit::Field.new(orientation: :responsive) do
              render PhlexKit::FieldContent.new do
                render PhlexKit::FieldLabel.new(for: "set-store-name") { "Store name" }
                render PhlexKit::FieldDescription.new { "Shown on your public storefront." }
              end
              render PhlexKit::Input.new(id: "set-store-name", value: "Harbor Supply Co.", class: "adm-field-control")
            end
            render PhlexKit::Field.new(orientation: :responsive) do
              render PhlexKit::FieldContent.new do
                render PhlexKit::FieldLabel.new(for: "set-support") { "Support email" }
                render PhlexKit::FieldDescription.new { "Order confirmations reply here." }
              end
              render PhlexKit::Input.new(id: "set-support", type: :email, value: "support@harbor.example", class: "adm-field-control")
            end
            render PhlexKit::Field.new(orientation: :responsive) do
              render PhlexKit::FieldContent.new do
                render PhlexKit::FieldLabel.new(for: "set-currency") { "Currency" }
                render PhlexKit::FieldDescription.new { "Prices convert at checkout." }
              end
              render PhlexKit::NativeSelect.new(id: "set-currency", class: "adm-field-control") do
                render PhlexKit::NativeSelectOption.new(value: "gbp", selected: true) { "GBP — British Pound" }
                render PhlexKit::NativeSelectOption.new(value: "usd") { "USD — US Dollar" }
                render PhlexKit::NativeSelectOption.new(value: "eur") { "EUR — Euro" }
              end
            end
          end
        end
      end

      def payments_section
        render PhlexKit::FieldSet.new(id: "payments") do
          render PhlexKit::FieldLegend.new { "Payments" }
          render PhlexKit::FieldDescription.new { "How Harbor captures and settles card payments." }
          render PhlexKit::FieldGroup.new do
            switch_row("set-test-mode", "Test mode", "Process payments against the sandbox.", checked: false)
            switch_row("set-auto-capture", "Auto-capture", "Capture authorised payments immediately.", checked: true)
            render PhlexKit::Field.new(orientation: :responsive) do
              render PhlexKit::FieldContent.new do
                render PhlexKit::FieldLabel.new(for: "set-descriptor") { "Statement descriptor" }
                render PhlexKit::FieldDescription.new { "What customers see on their card statement." }
              end
              render PhlexKit::Input.new(id: "set-descriptor", value: "HARBOR* ORDER", class: "adm-field-control")
            end
          end
        end
      end

      def notifications_section
        render PhlexKit::FieldSet.new(id: "notifications") do
          render PhlexKit::FieldLegend.new { "Notifications" }
          render PhlexKit::FieldDescription.new { "What lands in your team's inbox." }
          render PhlexKit::FieldGroup.new do
            switch_row("set-notif-orders", "New orders", "Every order, as it's placed.", checked: true)
            switch_row("set-notif-stock", "Low stock", "When a product crosses its reorder point.", checked: true)
            switch_row("set-notif-digest", "Weekly digest", "Revenue and fulfilment summary, Mondays.", checked: false)
          end
        end
      end

      def team_section
        render PhlexKit::FieldSet.new(id: "team") do
          render PhlexKit::FieldLegend.new { "Team" }
          render PhlexKit::FieldDescription.new { "People with access to this store." }
          render PhlexKit::FieldGroup.new do
            div(class: "adm-team-row") do
              render PhlexKit::AvatarGroup.new do
                %w[MK JT RS].each do |initials|
                  render PhlexKit::Avatar.new(size: :sm) { render PhlexKit::AvatarFallback.new { initials } }
                end
                render PhlexKit::AvatarGroupCount.new { "+2" }
              end
              span(class: "adm-muted") { "5 members · 2 admins" }
            end
            render PhlexKit::Field.new(orientation: :responsive) do
              render PhlexKit::FieldContent.new do
                render PhlexKit::FieldLabel.new(for: "set-invite") { "Invite someone" }
                render PhlexKit::FieldDescription.new { "They'll get an email with a join link." }
              end
              render PhlexKit::InputGroup.new(class: "adm-field-control") do
                render PhlexKit::Input.new(id: "set-invite", type: :email, placeholder: "name@company.com")
                render PhlexKit::InputGroupButton.new do
                  render PhlexKit::Button.new(variant: :outline, size: :sm) { "Send invite" }
                end
              end
            end
          end
        end
      end

      def switch_row(id, title, description, checked:)
        render PhlexKit::Field.new(orientation: :horizontal) do
          render PhlexKit::FieldContent.new do
            render PhlexKit::FieldLabel.new(for: id) { title }
            render PhlexKit::FieldDescription.new { description }
          end
          render PhlexKit::Switch.new(id: id, name: id, checked: checked)
        end
      end

      def local_css
        <<~CSS
          .adm-settings { width: min(46rem, 100%); padding-bottom: 0; }
          .adm-settings .pk-field-set { scroll-margin-top: 4rem; }
          .adm-field-control { max-width: 20rem; }
          .adm-team-row { display: flex; align-items: center; gap: .75rem; }
          .adm-save-bar { position: sticky; bottom: 0; display: flex; align-items: center; gap: .5rem;
                          justify-content: flex-end; padding: .75rem 0; margin-top: .5rem;
                          background: var(--pk-bg); border-top: 1px solid var(--pk-border); }
          .adm-save-bar .adm-muted { margin-right: auto; font-size: .75rem; }
          .adm-topbar-crumb { font-size: .8125rem; }
        CSS
      end
    end
  end
end
