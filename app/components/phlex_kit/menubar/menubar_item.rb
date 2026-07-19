module PhlexKit
  # Menu row (an <a> — pass href:, or as: :div for buttons). `variant:
  # :destructive` tints red; `inset: true` aligns with checkbox/radio rows.
  # Closes the bar. `disabled: true` marks the row inert (skipped by roving
  # focus, pointer-events off). See menubar.rb.
  class MenubarItem < BaseComponent
    VARIANTS = { default: nil, destructive: "destructive" }.freeze

    def initialize(as: :a, href: nil, shortcut: nil, variant: :default, inset: false, disabled: false, **attrs)
      @as = as.to_sym
      @href = href
      @shortcut = shortcut
      @variant = variant.to_sym
      @inset = inset
      @disabled = disabled
      @attrs = attrs
    end

    def view_template(&block)
      base = {
        class: [ "pk-menubar-item", fetch_option(VARIANTS, @variant, :variant), ("inset" if @inset) ].compact.join(" "),
        data: @disabled ? { disabled: "true" } : { action: "click->phlex-kit--menubar#close" }
      }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menuitem" unless attr_set?(:role)
      base[:tabindex] = "-1" unless attr_set?(:tabindex)
      base[:"aria-disabled"] = "true" if @disabled && !aria_key_set?(:disabled)
      # No default href: "#" would make Enter/click navigate (hash change +
      # scroll-to-top). tabindex="-1" keeps the row programmatically focusable.
      base[:href] = @href unless @href.nil? || @as == :div || @disabled
      send(@as, **mix(base, @attrs)) do
        block&.call
        span(class: "pk-menubar-shortcut") { @shortcut } if @shortcut
      end
    end
  end
end
