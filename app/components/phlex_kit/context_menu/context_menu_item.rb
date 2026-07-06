module PhlexKit
  # A menu row in a PhlexKit::ContextMenuContent. Matches the dropdown-menu
  # grammar: gap-based layout (no forced inset), `variant: :destructive`,
  # `checked:` renders a leading ✓, `shortcut:` a trailing kbd hint (or
  # compose ContextMenuShortcut yourself). Closes the menu on click.
  # See context_menu.rb.
  class ContextMenuItem < BaseComponent
    VARIANTS = { default: nil, destructive: "destructive" }.freeze

    def initialize(href: "#", checked: false, shortcut: nil, disabled: false, variant: :default, **attrs)
      @href = href
      @checked = checked
      @shortcut = shortcut
      @disabled = disabled
      @variant = variant.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      classes = [ "pk-context-menu-item", fetch_option(VARIANTS, @variant, :variant) ].compact.join(" ")
      base = { href: @href, role: "menuitem", tabindex: "-1", class: classes,
               data: { action: ("click->phlex-kit--context-menu#close" unless @disabled),
                       phlex_kit__context_menu_target: "menuItem",
                       disabled: (@disabled ? "true" : nil) }.compact }
      base[:aria] = { disabled: "true" } if @disabled
      a(**mix(base, @attrs)) do
        if @checked
          span(class: "pk-context-menu-check") do
            render Icon.new(:check, size: nil)
          end
        end
        yield
        span(class: "pk-context-menu-shortcut") { @shortcut } if @shortcut
      end
    end
  end
end
