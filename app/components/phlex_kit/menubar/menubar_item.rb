module PhlexKit
  # Menu row (an <a> — pass href:, or as: :div for buttons). Closes the bar.
  # See menubar.rb.
  class MenubarItem < BaseComponent
    def initialize(as: :a, href: "#", shortcut: nil, **attrs)
      @as = as.to_sym
      @href = href
      @shortcut = shortcut
      @attrs = attrs
    end

    def view_template(&block)
      base = {
        role: "menuitem",
        tabindex: "-1",
        class: "pk-menubar-item",
        data: { action: "click->phlex-kit--menubar#close" }
      }
      base[:href] = @href unless @as == :div
      send(@as, **mix(base, @attrs)) do
        block&.call
        span(class: "pk-menubar-shortcut") { @shortcut } if @shortcut
      end
    end
  end
end
