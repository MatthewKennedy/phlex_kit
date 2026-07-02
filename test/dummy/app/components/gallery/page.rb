# frozen_string_literal: true

module Gallery
  # Kitchen-sink page rendering every PhlexKit component family — the visual
  # validation surface for the kit. Order roughly: statics → form controls →
  # popups/overlays → composites. Each demo is deliberately small; the point is
  # that everything renders and every controller wires up with only
  # @hotwired/stimulus registered.
  class Page < Phlex::HTML
    include Phlex::Rails::Helpers::StylesheetLinkTag
    include Phlex::Rails::Helpers::JavaScriptImportmapTags
    include Phlex::Rails::Helpers::JavaScriptIncludeTag

    def view_template
      doctype
      html(data_theme: "dark") do
        head do
          title { "PhlexKit Gallery" }
          meta(charset: "utf-8")
          meta(name: "viewport", content: "width=device-width,initial-scale=1")
          stylesheet_link_tag "phlex_kit/phlex_kit"
          # The chart wrapper bundles no library — the dummy host supplies
          # window.Chart (vendored chart.js), exactly as a real host would.
          javascript_include_tag "chartjs.umd"
          javascript_importmap_tags
          style { gallery_css }
          # Dev aid: surface JS errors on-page (the gallery is often eyeballed
          # over a screenshot where the console isn't visible).
          script do
            safe(<<~JS)
              window.addEventListener("error", (e) => {
                let bar = document.getElementById("js-errors");
                if (!bar) {
                  bar = document.createElement("pre");
                  bar.id = "js-errors";
                  bar.style.cssText = "position:fixed;top:0;left:0;right:0;z-index:9999;background:#7f1d1d;color:#fff;padding:8px 12px;font-size:12px;white-space:pre-wrap;margin:0;";
                  document.body?.appendChild(bar);
                }
                bar.textContent += `JS ERROR: ${e.message} @ ${e.filename?.split("/").pop()}:${e.lineno}\\n`;
              });
            JS
          end
        end
        body do
          page_header
          main do
            typography_demo
            buttons_demo
            badges_demo
            alerts_demo
            card_demo
            statics_demo
            empty_demo
            breadcrumb_demo
            pagination_demo
            table_demo
            inputs_demo
            form_demo
            native_select_demo
            select_demo
            combobox_demo
            toggles_demo
            collapsible_demo
            accordion_demo
            tabs_demo
            dropdown_demo
            context_menu_demo
            popover_demo
            hover_card_demo
            tooltip_demo
            dialog_demo
            alert_dialog_demo
            sheet_demo
            command_demo
            clipboard_demo
            codeblock_demo
            messages_demo
            message_scroller_demo
            carousel_demo
            calendar_demo
            date_picker_demo
            data_table_demo
            chart_demo
            sidebar_demo
            shadcn_additions_demo
            slider_otp_drawer_demo
            toast_demo
          end
          # Mounted once, at the end of <body>: receives both the server flash
          # below and the client spawns from the Toast section's buttons.
          render PhlexKit::ToastRegion.new(close_button: true, flash: { "notice" => "Gallery loaded — 53/53 components" })
        end
      end
    end

    private

    def page_header
      header(class: "gallery-header") do
        div do
          h1 { "PhlexKit Gallery" }
          p { "Every component, rendered by the dummy host app. Vanilla CSS + --pk-* tokens; @hotwired/stimulus only." }
        end
        render PhlexKit::ThemeToggle.new { "🌓" }
      end
    end

    def demo(title, note: nil, &block)
      section(class: "gallery-section", id: title.downcase.gsub(/[^a-z0-9]+/, "-")) do
        h2 { title }
        p(class: "gallery-note") { note } if note
        div(class: "gallery-demo", &block)
      end
    end

    # --- statics ---------------------------------------------------------

    def typography_demo
      demo("Typography") do
        div(class: "stack") do
          render PhlexKit::Heading.new(level: 2) { "The quick brown fox" }
          render PhlexKit::Text.new { "Body text with an #{"inline"} run." }
          render PhlexKit::Text.new(as: :p) do
            plain "Includes "
            render PhlexKit::InlineCode.new { "inline_code" }
            plain " and an "
            render PhlexKit::InlineLink.new(href: "#typography") { "inline link" }
            plain "."
          end
          render PhlexKit::Blockquote.new { "Stay hungry. Stay foolish." }
        end
      end
    end

    def buttons_demo
      demo("Button + Link") do
        render PhlexKit::Button.new { "Primary" }
        render PhlexKit::Button.new(variant: :secondary) { "Secondary" }
        render PhlexKit::Button.new(variant: :destructive) { "Destructive" }
        render PhlexKit::Button.new(variant: :outline) { "Outline" }
        render PhlexKit::Button.new(variant: :ghost) { "Ghost" }
        render PhlexKit::Button.new(variant: :link) { "Link-style" }
        render PhlexKit::Button.new(size: :sm, variant: :outline) { "Small" }
        render PhlexKit::Button.new(size: :lg) { "Large" }
        render PhlexKit::Button.new(icon: true, variant: :outline, aria: { label: "Settings" }) { "⚙" }
        render PhlexKit::Link.new(href: "#buttons-link") { "A Link component" }
      end
    end

    def badges_demo
      demo("Badge + ShortcutKey + Stars") do
        render PhlexKit::Badge.new { "Primary" }
        render PhlexKit::Badge.new(variant: :secondary) { "Secondary" }
        render PhlexKit::Badge.new(size: :sm) { "sm" }
        render PhlexKit::ShortcutKey.new { "⌘" }
        render PhlexKit::ShortcutKey.new { "K" }
        render PhlexKit::Stars.new(rating: 3.5)
      end
    end

    def alerts_demo
      demo("Alert") do
        div(class: "stack grow") do
          render PhlexKit::Alert.new do
            render PhlexKit::AlertTitle.new { "Heads up!" }
            render PhlexKit::AlertDescription.new { "You can theme all of this by redefining --pk-* on :root." }
          end
          render PhlexKit::Alert.new(variant: :destructive) do
            render PhlexKit::AlertTitle.new { "Something broke" }
            render PhlexKit::AlertDescription.new { "The destructive variant maps to --pk-red." }
          end
        end
      end
    end

    def card_demo
      demo("Card + Separator + AspectRatio") do
        render PhlexKit::Card.new(class: "w-sm") do
          render PhlexKit::CardHeader.new do
            render PhlexKit::CardTitle.new { "Card title" }
            render PhlexKit::CardDescription.new { "Card description under the title." }
          end
          render PhlexKit::CardContent.new do
            render PhlexKit::AspectRatio.new(aspect_ratio: "16/9") do
              div(class: "placeholder-media") { "16 / 9" }
            end
            render PhlexKit::Separator.new(class: "my")
            plain "Content below a separator."
          end
          render PhlexKit::CardFooter.new do
            render PhlexKit::Button.new(size: :sm) { "Action" }
          end
        end
      end
    end

    def statics_demo
      demo("Avatar + Skeleton + Progress") do
        render PhlexKit::Avatar.new do
          render PhlexKit::AvatarImage.new(src: "https://i.pravatar.cc/64?img=13", alt: "User")
          render PhlexKit::AvatarFallback.new { "MK" }
        end
        render PhlexKit::Avatar.new(size: :sm) do
          render PhlexKit::AvatarFallback.new { "PK" }
        end
        div(class: "stack w-sm") do
          render PhlexKit::Skeleton.new(class: "skeleton-line")
          render PhlexKit::Skeleton.new(class: "skeleton-line short")
          render PhlexKit::Progress.new(value: 66)
        end
      end
    end

    def empty_demo
      demo("Empty") do
        render PhlexKit::Empty.new(class: "w-md") do
          render PhlexKit::EmptyHeader.new do
            render PhlexKit::EmptyMedia.new { "📭" }
            render PhlexKit::EmptyTitle.new { "No reviews yet" }
            render PhlexKit::EmptyDescription.new { "When customers leave reviews they show up here." }
          end
          render PhlexKit::EmptyContent.new do
            render PhlexKit::Button.new(size: :sm, variant: :outline) { "Invite reviews" }
          end
        end
      end
    end

    def breadcrumb_demo
      demo("Breadcrumb") do
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
            render PhlexKit::BreadcrumbItem.new do
              render PhlexKit::BreadcrumbPage.new { "Gallery" }
            end
          end
        end
      end
    end

    def pagination_demo
      demo("Pagination") do
        render PhlexKit::Pagination.new do
          render PhlexKit::PaginationContent.new do
            render PhlexKit::PaginationItem.new(href: "#") { "‹" }
            render PhlexKit::PaginationItem.new(href: "#") { "1" }
            render PhlexKit::PaginationItem.new(href: "#", active: true) { "2" }
            render PhlexKit::PaginationItem.new(href: "#") { "3" }
            render PhlexKit::PaginationEllipsis.new
            render PhlexKit::PaginationItem.new(href: "#") { "›" }
          end
        end
      end
    end

    def table_demo
      demo("Table") do
        render PhlexKit::Table.new(class: "w-lg") do
          render PhlexKit::TableCaption.new { "Recent invoices" }
          render PhlexKit::TableHeader.new do
            render PhlexKit::TableRow.new do
              render PhlexKit::TableHead.new { "Invoice" }
              render PhlexKit::TableHead.new { "Status" }
              render PhlexKit::TableHead.new { "Amount" }
            end
          end
          render PhlexKit::TableBody.new do
            [ %w[INV-001 Paid £250.00], %w[INV-002 Pending £150.00] ].each do |inv, status, amount|
              render PhlexKit::TableRow.new do
                render PhlexKit::TableCell.new { inv }
                render PhlexKit::TableCell.new { status }
                render PhlexKit::TableCell.new { amount }
              end
            end
          end
        end
      end
    end

    # --- form controls ---------------------------------------------------

    def inputs_demo
      demo("Input + Textarea + MaskedInput + Checkbox + Radio + Switch") do
        div(class: "stack w-md") do
          render PhlexKit::Input.new(placeholder: "Plain input")
          render PhlexKit::MaskedInput.new(placeholder: "Card: #### #### #### ####", data: { mask: "#### #### #### ####" })
          render PhlexKit::Textarea.new(rows: 2, placeholder: "Textarea")
        end
        div(class: "stack") do
          label(class: "row") do
            render PhlexKit::Checkbox.new(name: "cb")
            plain " Checkbox"
          end
          label(class: "row") do
            render PhlexKit::RadioButton.new(name: "rb", value: "1", checked: true)
            plain " Radio one"
          end
          label(class: "row") do
            render PhlexKit::RadioButton.new(name: "rb", value: "2")
            plain " Radio two"
          end
          label(class: "row") do
            render PhlexKit::Switch.new(name: "sw", checked: true)
            plain " Switch"
          end
        end
      end
    end

    def form_demo
      demo("Form + FormField (live validation)",
        note: "Submit empty or with a bad email — the error fills client-side and clears as you fix it.") do
        render PhlexKit::Form.new(action: "#form-form-field-live-validation", method: "get", class: "w-md") do
          render PhlexKit::FormField.new do
            render PhlexKit::FormFieldLabel.new(for: "demo-email") { "Email" }
            render PhlexKit::Input.new(
              type: :email, id: "demo-email", name: "email", required: true,
              placeholder: "you@example.com",
              data: { value_missing: "Email is required.", type_mismatch: "That doesn't look like an email." }
            )
            render PhlexKit::FormFieldHint.new { "We never share it." }
            render PhlexKit::FormFieldError.new
          end
          div(class: "pk-form-actions") do
            render PhlexKit::Button.new(type: :submit, size: :sm) { "Save" }
            render PhlexKit::Button.new(type: :reset, size: :sm, variant: :ghost) { "Reset" }
          end
        end
      end
    end

    def native_select_demo
      demo("NativeSelect") do
        div(class: "w-sm") { native_select_field }
      end
    end

    def native_select_field
      render PhlexKit::NativeSelect.new(name: "store") do
        render PhlexKit::NativeSelectOption.new(value: "") { "All stores" }
        render PhlexKit::NativeSelectGroup.new(label: "Live") do
          render PhlexKit::NativeSelectOption.new(value: "tkf") { "Tongkat Fitness" }
          render PhlexKit::NativeSelectOption.new(value: "sts") { "Sole Trader Support" }
        end
      end
    end

    def select_demo
      demo("Select (custom)") do
        div(class: "w-sm") do
          render PhlexKit::Select.new do
            render PhlexKit::SelectInput.new(name: "role", id: "role")
            render PhlexKit::SelectTrigger.new do
              render PhlexKit::SelectValue.new(placeholder: "Select a role")
            end
            render PhlexKit::SelectContent.new do
              render PhlexKit::SelectGroup.new do
                render PhlexKit::SelectLabel.new { "Roles" }
                render PhlexKit::SelectItem.new(value: "admin") { "Admin" }
                render PhlexKit::SelectItem.new(value: "editor") { "Editor" }
                render PhlexKit::SelectItem.new(value: "viewer") { "Viewer" }
              end
            end
          end
        end
      end
    end

    def combobox_demo
      demo("Combobox — button / input / badge triggers",
        note: "Left: multi-select with search + select-all. Middle: the field is the filter (single-select). Right: chips with backspace-remove and clear-all.") do
        div(class: "w-sm") { combobox_button_variant }
        div(class: "w-sm") { combobox_input_variant }
        div(class: "w-sm") { combobox_badge_variant }
      end
    end

    def combobox_button_variant
      render PhlexKit::Combobox.new(term: "fruits") do
        render PhlexKit::ComboboxTrigger.new(placeholder: "Select fruits")
        render PhlexKit::ComboboxPopover.new do
          render PhlexKit::ComboboxSearchInput.new(placeholder: "Search fruits…")
          render PhlexKit::ComboboxList.new do
            render PhlexKit::ComboboxItem.new do
              render PhlexKit::ComboboxToggleAllCheckbox.new
              span { "Select all" }
            end
            %w[Apple Banana Cherry].each do |fruit|
              render PhlexKit::ComboboxItem.new do
                render PhlexKit::ComboboxCheckbox.new(name: "fruits[]", value: fruit.downcase)
                span { fruit }
                render PhlexKit::ComboboxItemIndicator.new
              end
            end
            render PhlexKit::ComboboxEmptyState.new { "No fruits found" }
          end
        end
      end
    end

    def combobox_input_variant
      render PhlexKit::Combobox.new do
        render PhlexKit::ComboboxInputTrigger.new(placeholder: "Pick a city")
        render PhlexKit::ComboboxPopover.new do
          render PhlexKit::ComboboxList.new do
            %w[Amsterdam Berlin Copenhagen Dublin].each do |city|
              render PhlexKit::ComboboxItem.new do
                render PhlexKit::ComboboxRadio.new(name: "city", value: city.downcase)
                span { city }
                render PhlexKit::ComboboxItemIndicator.new
              end
            end
            render PhlexKit::ComboboxEmptyState.new { "No cities found" }
          end
        end
      end
    end

    def combobox_badge_variant
      render PhlexKit::Combobox.new(term: "tags") do
        render PhlexKit::ComboboxBadgeTrigger.new(placeholder: "Add tags", clear_button: true)
        render PhlexKit::ComboboxPopover.new do
          render PhlexKit::ComboboxList.new do
            %w[ruby rails phlex stimulus css].each do |tag|
              render PhlexKit::ComboboxItem.new do
                render PhlexKit::ComboboxCheckbox.new(name: "tags[]", value: tag)
                span { tag }
                render PhlexKit::ComboboxItemIndicator.new
              end
            end
            render PhlexKit::ComboboxEmptyState.new { "No tags found" }
          end
        end
      end
    end

    def toggles_demo
      demo("Toggle + ToggleGroup + ThemeToggle") do
        render PhlexKit::Toggle.new(name: "bold") { "B" }
        render PhlexKit::ToggleGroup.new(type: :single, name: "align", value: "left") do |group|
          group.ToggleGroupItem(value: "left") { "Left" }
          group.ToggleGroupItem(value: "center") { "Center" }
          group.ToggleGroupItem(value: "right") { "Right" }
        end
        render PhlexKit::ThemeToggle.new { "🌓" }
      end
    end

    def collapsible_demo
      demo("Collapsible") do
        render PhlexKit::Collapsible.new(class: "w-md") do
          render PhlexKit::CollapsibleTrigger.new do
            render PhlexKit::Button.new(variant: :outline, size: :sm) { "Toggle details" }
          end
          render PhlexKit::CollapsibleContent.new do
            div(class: "boxed") { "Hidden until toggled — no page reload, one Stimulus controller." }
          end
        end
      end
    end

    def accordion_demo
      demo("Accordion") do
        render PhlexKit::Accordion.new(class: "w-lg") do
          render PhlexKit::AccordionItem.new(open: true) do
            render PhlexKit::AccordionDefaultTrigger.new { "Is it accessible?" }
            render PhlexKit::AccordionContent.new do
              render PhlexKit::AccordionDefaultContent.new { "Yes — it keeps ruby_ui's ARIA structure." }
            end
          end
          render PhlexKit::AccordionItem.new do
            render PhlexKit::AccordionDefaultTrigger.new { "Is it animated?" }
            render PhlexKit::AccordionContent.new do
              render PhlexKit::AccordionDefaultContent.new { "Yes — native Web Animations API, no motion dependency." }
            end
          end
        end
      end
    end

    def tabs_demo
      demo("Tabs") do
        render PhlexKit::Tabs.new(default: "account", class: "w-lg") do
          render PhlexKit::TabsList.new do
            render PhlexKit::TabsTrigger.new(value: "account") { "Account" }
            render PhlexKit::TabsTrigger.new(value: "password") { "Password" }
          end
          render PhlexKit::TabsContent.new(value: "account") do
            div(class: "boxed") { "Account settings pane." }
          end
          render PhlexKit::TabsContent.new(value: "password") do
            div(class: "boxed") { "Password pane." }
          end
        end
      end
    end

    # --- popups / overlays -----------------------------------------------

    def dropdown_demo
      demo("DropdownMenu") do
        render PhlexKit::DropdownMenu.new do
          render PhlexKit::DropdownMenuTrigger.new do
            render PhlexKit::Button.new(variant: :outline) { "Open menu" }
          end
          render PhlexKit::DropdownMenuContent.new do
            render PhlexKit::DropdownMenuLabel.new { "My account" }
            render PhlexKit::DropdownMenuSeparator.new
            render PhlexKit::DropdownMenuItem.new(href: "#dropdownmenu") { "Profile" }
            render PhlexKit::DropdownMenuItem.new(href: "#dropdownmenu") { "Billing" }
            render PhlexKit::DropdownMenuSeparator.new
            render PhlexKit::DropdownMenuItem.new(href: "#dropdownmenu") { "Sign out" }
          end
        end
      end
    end

    def context_menu_demo
      demo("ContextMenu", note: "Right-click the dashed area.") do
        render PhlexKit::ContextMenu.new do
          render PhlexKit::ContextMenuTrigger.new do
            div(class: "dropzone") { "Right-click here" }
          end
          render PhlexKit::ContextMenuContent.new do
            render PhlexKit::ContextMenuLabel.new { "Actions" }
            render PhlexKit::ContextMenuItem.new(shortcut: "⌘C") { "Copy" }
            render PhlexKit::ContextMenuItem.new(checked: true) { "Show grid" }
            render PhlexKit::ContextMenuSeparator.new
            render PhlexKit::ContextMenuItem.new(disabled: true) { "Delete" }
          end
        end
      end
    end

    def popover_demo
      demo("Popover") do
        render PhlexKit::Popover.new do
          render PhlexKit::PopoverTrigger.new do
            render PhlexKit::Button.new(variant: :outline) { "Open popover" }
          end
          render PhlexKit::PopoverContent.new do
            plain "CSS-positioned panel — no floating-ui."
          end
        end
      end
    end

    def hover_card_demo
      demo("HoverCard", note: "Hover the trigger.") do
        render PhlexKit::HoverCard.new do
          render PhlexKit::HoverCardTrigger.new do
            render PhlexKit::Button.new(variant: :link) { "@phlex_kit" }
          end
          render PhlexKit::HoverCardContent.new do
            plain "53 components, no Tailwind, no build step."
          end
        end
      end
    end

    def tooltip_demo
      demo("Tooltip") do
        render PhlexKit::Tooltip.new do
          render PhlexKit::TooltipTrigger.new do
            render PhlexKit::Button.new(variant: :outline, size: :sm) { "Hover me" }
          end
          render PhlexKit::TooltipContent.new { "Tooltip content" }
        end
      end
    end

    def dialog_demo
      demo("Dialog") do
        render PhlexKit::Dialog.new do
          render PhlexKit::DialogTrigger.new do
            render PhlexKit::Button.new { "Open dialog" }
          end
          render PhlexKit::DialogContent.new do
            render PhlexKit::DialogHeader.new do
              render PhlexKit::DialogTitle.new { "Native <dialog>" }
              render PhlexKit::DialogDescription.new { "showModal(), ::backdrop, Escape — all free." }
            end
            render PhlexKit::DialogMiddle.new { "Dialog body content." }
            render PhlexKit::DialogFooter.new do
              render PhlexKit::Button.new(size: :sm, data: { action: "click->phlex-kit--dialog#dismiss" }) { "Done" }
            end
          end
        end
      end
    end

    def alert_dialog_demo
      demo("AlertDialog") do
        render PhlexKit::AlertDialog.new do
          render PhlexKit::AlertDialogTrigger.new do
            render PhlexKit::Button.new(variant: :destructive) { "Delete account" }
          end
          render PhlexKit::AlertDialogContent.new do
            render PhlexKit::AlertDialogHeader.new do
              render PhlexKit::AlertDialogTitle.new { "Are you absolutely sure?" }
              render PhlexKit::AlertDialogDescription.new { "This action cannot be undone." }
            end
            render PhlexKit::AlertDialogFooter.new do
              render PhlexKit::AlertDialogCancel.new { "Cancel" }
              render PhlexKit::AlertDialogAction.new { "Continue" }
            end
          end
        end
      end
    end

    def sheet_demo
      demo("Sheet") do
        render PhlexKit::Sheet.new do
          render PhlexKit::SheetTrigger.new do
            render PhlexKit::Button.new(variant: :outline) { "Open sheet" }
          end
          render PhlexKit::SheetContent.new(side: :right) do
            render PhlexKit::SheetHeader.new do
              render PhlexKit::SheetTitle.new { "Edit profile" }
              render PhlexKit::SheetDescription.new { "Slides in from the right; template-cloned into <body>." }
            end
            render PhlexKit::SheetMiddle.new { "Sheet body." }
            render PhlexKit::SheetFooter.new do
              render PhlexKit::Button.new(size: :sm, data: { action: "click->phlex-kit--sheet-content#close" }) { "Save" }
            end
          end
        end
      end
    end

    def command_demo
      demo("Command", note: "Also opens with ⌘K / Ctrl+K. Fuzzy filter: try “nb”.") do
        render PhlexKit::CommandDialog.new do
          render PhlexKit::CommandDialogTrigger.new do
            render PhlexKit::Button.new(variant: :outline) { "Command palette  ⌘K" }
          end
          render PhlexKit::CommandDialogContent.new do
            render PhlexKit::Command.new do
              render PhlexKit::CommandInput.new
              render PhlexKit::CommandList.new do
                render PhlexKit::CommandGroup.new(title: "Pages") do
                  render PhlexKit::CommandItem.new(value: "home", href: "#") { "Home" }
                  render PhlexKit::CommandItem.new(value: "new branch", href: "#") { "New branch" }
                  render PhlexKit::CommandItem.new(value: "settings", href: "#") { "Settings" }
                end
                render PhlexKit::CommandGroup.new(title: "Actions") do
                  render PhlexKit::CommandItem.new(value: "sales report", href: "#") { "Sales report" }
                  render PhlexKit::CommandItem.new(value: "sign out", href: "#") { "Sign out" }
                end
              end
              render PhlexKit::CommandEmpty.new { "No results found." }
            end
          end
        end
      end
    end

    def clipboard_demo
      demo("Clipboard") do
        render PhlexKit::Clipboard.new do
          div(class: "row") do
            render PhlexKit::ClipboardSource.new { code { "gem install phlex_kit" } }
            render PhlexKit::ClipboardTrigger.new do
              render PhlexKit::Button.new(variant: :outline, size: :sm) { "Copy" }
            end
          end
        end
      end
    end

    def codeblock_demo
      demo("Codeblock", note: "Plain by design — no rouge; bring your own highlighter.") do
        render PhlexKit::Codeblock.new(<<~RUBY, syntax: :ruby, class: "w-lg")
          render PhlexKit::Button.new(variant: :primary) { "Approve" }
        RUBY
      end
    end

    def messages_demo
      demo("Message + Bubble") do
        div(class: "stack w-lg") do
          render PhlexKit::MessageGroup.new do
            render PhlexKit::Message.new do
              render PhlexKit::MessageAvatar.new do
                render PhlexKit::Avatar.new(size: :sm) { render PhlexKit::AvatarFallback.new { "A" } }
              end
              render PhlexKit::MessageContent.new do
                render PhlexKit::MessageHeader.new { "Alice" }
                render PhlexKit::BubbleGroup.new do
                  render PhlexKit::Bubble.new(variant: :secondary) do
                    render PhlexKit::BubbleContent.new { "Hey — did the port land?" }
                  end
                end
              end
            end
            render PhlexKit::Message.new(align: :end) do
              render PhlexKit::MessageContent.new do
                render PhlexKit::BubbleGroup.new do
                  render PhlexKit::Bubble.new(align: :end) do
                    render PhlexKit::BubbleContent.new { "53/53, suite green ✅" }
                  end
                end
                render PhlexKit::MessageFooter.new { "Just now" }
              end
            end
          end
        end
      end
    end

    def message_scroller_demo
      demo("MessageScroller", note: "Pinned to bottom; scroll up to unpin.") do
        div(class: "scroller-frame w-lg") do
          render PhlexKit::MessageScroller.new do
            div(class: "scroller-viewport", data: { phlex_kit__message_scroller_target: "viewport" }) do
              div(class: "scroller-content", data: { phlex_kit__message_scroller_target: "content" }) do
                12.times do |i|
                  render PhlexKit::Message.new(align: i.even? ? :start : :end) do
                    render PhlexKit::MessageContent.new do
                      render PhlexKit::Bubble.new(align: i.even? ? :start : :end, variant: i.even? ? :secondary : :default) do
                        render PhlexKit::BubbleContent.new { "Message #{i + 1}" }
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    # --- composites ------------------------------------------------------

    def carousel_demo
      demo("Carousel", note: "Arrow keys, buttons, or drag/swipe.") do
        div(class: "carousel-frame") do
          render PhlexKit::Carousel.new(tabindex: "0", class: "w-md") do
            render PhlexKit::CarouselContent.new do
              3.times do |i|
                render PhlexKit::CarouselItem.new do
                  div(class: "placeholder-media slide") { "Slide #{i + 1}" }
                end
              end
            end
            render PhlexKit::CarouselPrevious.new
            render PhlexKit::CarouselNext.new
          end
        end
      end
    end

    def calendar_demo
      demo("Calendar") do
        div(class: "boxed") do
          render PhlexKit::Calendar.new(selected_date: Date.today, min_date: Date.today - 365)
        end
      end
    end

    def date_picker_demo
      demo("DatePicker") do
        render PhlexKit::DatePicker.new(id: "delivery-date", name: "delivery_date", label: "Delivery date")
      end
    end

    def data_table_demo
      demo("DataTable", note: "Selection, sort links, column toggle, per-page + pagination (links point back at this page).") do
        render PhlexKit::DataTable.new(id: "gallery-reviews") do
          render PhlexKit::DataTableToolbar.new do
            render PhlexKit::DataTableSearch.new(path: "/", frame_id: "gallery-reviews", placeholder: "Search reviews…")
            render PhlexKit::DataTableBulkActions.new do
              # In a real app this is a submit button inside a DataTableForm
              # (POSTs the checked ids[]). The demo has no endpoint, so it
              # toasts the selection instead.
              render PhlexKit::Button.new(
                variant: :destructive, size: :sm,
                onclick: safe(
                  "const ids = [...this.closest('[data-controller~=\"phlex-kit--data-table\"]')" \
                  ".querySelectorAll('input[data-phlex-kit--data-table-target=\"rowCheckbox\"]:checked')].map(el => el.value); " \
                  "PhlexKit.toast.error(`Would delete ${ids.length} review(s)`, { description: `ids: ${ids.join(', ')}` })"
                )
              ) { "Delete selected" }
            end
            render PhlexKit::DataTableColumnToggle.new(columns: [ { key: "status", label: "Status" }, { key: "rating", label: "Rating" } ])
          end
          render PhlexKit::Table.new do
            render PhlexKit::TableHeader.new do
              render PhlexKit::TableRow.new do
                render PhlexKit::TableHead.new { render PhlexKit::DataTableSelectAllCheckbox.new }
                render PhlexKit::DataTableSortHead.new(column_key: :product, label: "Product", path: "/")
                render PhlexKit::TableHead.new(data: { column: "status" }) { "Status" }
                render PhlexKit::TableHead.new(data: { column: "rating" }) { "Rating" }
                render PhlexKit::TableHead.new { "" }
              end
            end
            render PhlexKit::TableBody.new do
              [ [ 1, "TKA 1-200", "Published", "★★★★★" ], [ 2, "TKA 1-100", "Pending", "★★★☆☆" ], [ 3, "Gift card", "Published", "★★★★☆" ] ].each do |id, product, status, rating|
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableCell.new { render PhlexKit::DataTableRowCheckbox.new(value: id) }
                  render PhlexKit::TableCell.new { product }
                  render PhlexKit::TableCell.new(data: { column: "status" }) { status }
                  render PhlexKit::TableCell.new(data: { column: "rating" }) { rating }
                  render PhlexKit::TableCell.new { render PhlexKit::DataTableExpandToggle.new(controls: "review-#{id}-detail") }
                end
                render PhlexKit::TableRow.new(id: "review-#{id}-detail", class: "pk-hidden") do
                  render PhlexKit::TableCell.new(colspan: 5) { "Expanded detail for #{product}." }
                end
              end
            end
          end
          render PhlexKit::DataTablePaginationBar.new do
            render PhlexKit::DataTableSelectionSummary.new(total_on_page: 3)
            div(class: "row") do
              render PhlexKit::DataTablePerPageSelect.new(path: "/", value: 10, frame_id: "gallery-reviews")
              render PhlexKit::DataTablePagination.new(page: 2, per_page: 10, total_count: 87, path: "/")
            end
          end
        end
      end
    end

    def chart_demo
      demo("Chart", note: "Thin wrapper — the host supplies the library (this page vendors chart.js as window.Chart). Series take --pk-chart-1..5.") do
        labels = %w[Jan Feb Mar Apr May Jun]
        div(class: "chart-frame") do
          render PhlexKit::Chart.new(options: {
            type: "line",
            data: { labels: labels, datasets: [
              { label: "Desktop", data: [ 186, 305, 237, 173, 209, 214 ], fill: true },
              { label: "Mobile", data: [ 80, 200, 120, 190, 130, 140 ], fill: true }
            ] },
            options: { plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } } } }
          })
        end
        div(class: "chart-frame") do
          render PhlexKit::Chart.new(options: {
            type: "bar",
            data: { labels: labels, datasets: [ { label: "Revenue", data: [ 12, 19, 14, 22, 17, 25 ], borderWidth: 0, borderRadius: 4 } ] },
            options: { plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } } } }
          })
        end
        div(class: "chart-frame") do
          render PhlexKit::Chart.new(options: {
            type: "doughnut",
            data: { labels: %w[Chrome Safari Firefox Edge Other], datasets: [ { data: [ 275, 200, 187, 173, 90 ] } ] },
            options: { cutout: "60%" }
          })
        end
      end
    end

    def sidebar_demo
      demo("Sidebar") do
        div(class: "sidebar-frame") do
          render PhlexKit::SidebarWrapper.new do
            render PhlexKit::Sidebar.new do
              render PhlexKit::SidebarHeader.new { "Aypex Admin" }
              render PhlexKit::SidebarContent.new do
                render PhlexKit::SidebarGroup.new do
                  render PhlexKit::SidebarMenu.new do
                    render PhlexKit::SidebarMenuItem.new do
                      render PhlexKit::SidebarMenuButton.new(active: true) { "Dashboard" }
                    end
                    render PhlexKit::SidebarMenuItem.new do
                      render PhlexKit::SidebarMenuButton.new { "Reviews" }
                    end
                    render PhlexKit::SidebarMenuItem.new do
                      render PhlexKit::SidebarMenuButton.new { "Settings" }
                    end
                  end
                end
              end
              render PhlexKit::SidebarFooter.new { "v0.1.0" }
            end
            render PhlexKit::SidebarInset.new do
              div(class: "boxed") { "Main content beside the sidebar." }
            end
          end
        end
      end
    end

    def shadcn_additions_demo
      demo("Spinner + Kbd + Label + ButtonGroup + Item + InputGroup + RadioGroup + ScrollArea",
        note: "shadcn/ui components beyond the ruby_ui catalog.") do
        render PhlexKit::Spinner.new
        render PhlexKit::Spinner.new(size: :lg)
        render PhlexKit::KbdGroup.new do
          render PhlexKit::Kbd.new { "⌘" }
          render PhlexKit::Kbd.new { "K" }
        end
        render PhlexKit::ButtonGroup.new do
          render PhlexKit::Button.new(variant: :outline, size: :sm) { "Day" }
          render PhlexKit::Button.new(variant: :outline, size: :sm) { "Week" }
          render PhlexKit::Button.new(variant: :outline, size: :sm) { "Month" }
        end
        div(class: "stack w-md") do
          render PhlexKit::InputGroup.new do
            render PhlexKit::InputGroupAddon.new do
              render PhlexKit::InputGroupText.new { "https://" }
            end
            render PhlexKit::Input.new(placeholder: "example.com", name: "url")
            render PhlexKit::InputGroupAddon.new(align: :end) do
              render PhlexKit::Spinner.new(size: :sm)
            end
          end
          render PhlexKit::RadioGroup.new do
            render PhlexKit::Label.new do
              render PhlexKit::RadioButton.new(name: "plan", value: "starter", checked: true)
              plain "Starter"
            end
            render PhlexKit::Label.new do
              render PhlexKit::RadioButton.new(name: "plan", value: "pro")
              plain "Pro"
            end
          end
        end
        div(class: "w-md") do
          render PhlexKit::ItemGroup.new do
            render PhlexKit::Item.new(variant: :outline) do
              render PhlexKit::ItemMedia.new { "📦" }
              render PhlexKit::ItemContent.new do
                render PhlexKit::ItemTitle.new { "phlex_kit 0.1.0" }
                render PhlexKit::ItemDescription.new { "53 → 64 components and counting." }
              end
              render PhlexKit::ItemActions.new do
                render PhlexKit::Button.new(size: :sm, variant: :outline) { "Update" }
              end
            end
          end
        end
        div(class: "w-sm", style: "height: 120px") do
          render PhlexKit::ScrollArea.new(style: "height: 100%") do
            10.times { |i| div(class: "pk-item") { "Scrollable row #{i + 1}" } }
          end
        end
      end
    end

    def slider_otp_drawer_demo
      demo("Slider + InputOTP + Drawer", note: "Native range slider; OTP with paste distribution; bottom drawer on the sheet machinery.") do
        div(class: "w-md") { render PhlexKit::Slider.new(name: "volume", value: 35) }
        render PhlexKit::InputOtp.new(length: 6, name: "code") do
          render PhlexKit::InputOtpGroup.new do
            3.times { render PhlexKit::InputOtpSlot.new }
          end
          render PhlexKit::InputOtpSeparator.new
          render PhlexKit::InputOtpGroup.new do
            3.times { render PhlexKit::InputOtpSlot.new }
          end
        end
        render PhlexKit::Drawer.new do
          render PhlexKit::DrawerTrigger.new do
            render PhlexKit::Button.new(variant: :outline) { "Open drawer" }
          end
          render PhlexKit::DrawerContent.new do
            render PhlexKit::DrawerHeader.new do
              render PhlexKit::DrawerTitle.new { "Move goal" }
              render PhlexKit::DrawerDescription.new { "Bottom sheet with a grab handle — vaul replaced by the kit's own clone machinery." }
            end
            render PhlexKit::DrawerFooter.new do
              render PhlexKit::DrawerClose.new do
                render PhlexKit::Button.new { "Done" }
              end
            end
          end
        end
      end
    end

    def toast_demo
      demo("Toast", note: "The region is mounted at the end of <body>; a server flash toast fired on page load.") do
        render PhlexKit::Button.new(size: :sm, onclick: safe("PhlexKit.toast('Plain toast')")) { "Default" }
        render PhlexKit::Button.new(size: :sm, onclick: safe("PhlexKit.toast.success('Saved', { description: 'Your changes are live.' })")) { "Success" }
        render PhlexKit::Button.new(size: :sm, variant: :destructive, onclick: safe("PhlexKit.toast.error('Failed', { description: 'Try again.' })")) { "Error" }
        render PhlexKit::Button.new(size: :sm, variant: :outline, onclick: safe("PhlexKit.toast.warning('Careful')")) { "Warning" }
        render PhlexKit::Button.new(size: :sm, variant: :outline, onclick: safe("PhlexKit.toast.promise(new Promise(r => setTimeout(r, 1500)), { loading: 'Deploying…', success: 'Deployed', error: 'Rollback' })")) { "Promise" }
        render PhlexKit::Button.new(size: :sm, variant: :ghost, onclick: safe("PhlexKit.toast.dismiss()")) { "Dismiss all" }
      end
    end

    # Chrome for the gallery itself — not part of the kit.
    def gallery_css
      <<~CSS
        body { margin: 0; padding: 2rem clamp(1rem, 4vw, 3rem) 6rem; background: var(--pk-bg); color: var(--pk-text);
               font: 15px/1.5 system-ui, -apple-system, sans-serif; }
        .gallery-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 1rem; margin-bottom: 2rem; }
        .gallery-header h1 { margin: 0 0 .25rem; font-size: 1.5rem; }
        .gallery-header p { margin: 0; color: var(--pk-muted); }
        .gallery-section { border: 1px solid var(--pk-border); border-radius: var(--pk-radius); background: var(--pk-surface);
                           padding: 1.25rem 1.5rem 1.5rem; margin-bottom: 1.25rem; }
        .gallery-section h2 { margin: 0 0 .75rem; font-size: .8rem; font-weight: 600; letter-spacing: .08em;
                              text-transform: uppercase; color: var(--pk-muted); }
        .gallery-note { margin: -.5rem 0 .75rem; font-size: .85rem; color: var(--pk-muted); }
        .gallery-demo { display: flex; flex-wrap: wrap; gap: 1rem; align-items: flex-start; }
        .stack { display: flex; flex-direction: column; gap: .75rem; }
        .row { display: flex; align-items: center; gap: .5rem; }
        .grow { flex: 1; min-width: 280px; }
        .w-sm { width: 300px; max-width: 100%; }
        .w-md { width: 380px; max-width: 100%; }
        .w-lg { width: 560px; max-width: 100%; }
        .my { margin-block: .75rem; }
        .boxed { border: 1px dashed var(--pk-border); border-radius: .375rem; padding: 1rem; }
        .dropzone { border: 1px dashed var(--pk-border); border-radius: .375rem; padding: 2.5rem 3rem; color: var(--pk-muted); }
        .placeholder-media { display: flex; align-items: center; justify-content: center; width: 100%; height: 100%;
                             background: var(--pk-surface-2); border-radius: .375rem; color: var(--pk-muted); }
        .placeholder-media.slide { height: 140px; font-size: 1.25rem; }
        .skeleton-line { height: 1rem; width: 100%; }
        .skeleton-line.short { width: 60%; }
        .scroller-frame { height: 220px; }
        .scroller-viewport { height: 100%; overflow-y: auto; }
        .scroller-content { display: flex; flex-direction: column; gap: .5rem; padding: .25rem; }
        .carousel-frame { padding: 0 3.5rem; }
        .sidebar-frame { width: 100%; max-width: 640px; height: 300px; overflow: hidden;
                         border: 1px solid var(--pk-border); border-radius: .375rem; }
        .sidebar-frame .pk-sidebar { height: 100%; }
        .chart-frame { width: 300px; max-width: 100%; }
      CSS
    end
  end
end
