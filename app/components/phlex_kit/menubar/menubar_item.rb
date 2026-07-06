module PhlexKit
  # Menu row (an <a> — pass href:, or as: :div for buttons). `variant:
  # :destructive` tints red; `inset: true` aligns with checkbox/radio rows.
  # Closes the bar. `disabled: true` marks the row inert (skipped by roving
  # focus, pointer-events off). See menubar.rb.
  class MenubarItem < BaseComponent
    VARIANTS = { default: nil, destructive: "destructive" }.freeze

    def initialize(as: :a, href: "#", shortcut: nil, variant: :default, inset: false, disabled: false, **attrs)
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
        role: "menuitem",
        tabindex: "-1",
        class: [ "pk-menubar-item", VARIANTS.fetch(@variant), ("inset" if @inset) ].compact.join(" "),
        data: @disabled ? { disabled: "true" } : { action: "click->phlex-kit--menubar#close" }
      }
      base[:aria] = { disabled: "true" } if @disabled
      base[:href] = @href unless @as == :div || @disabled
      send(@as, **mix(base, @attrs)) do
        block&.call
        span(class: "pk-menubar-shortcut") { @shortcut } if @shortcut
      end
    end
  end
end
