module PhlexKit
  class ContextMenuItem < BaseComponent
    def initialize(href: "#", checked: false, shortcut: nil, disabled: false, **attrs)
      @href = href
      @checked = checked
      @shortcut = shortcut
      @disabled = disabled
      @attrs = attrs
    end
    def view_template(&block)
      a(**mix({ href: @href, role: "menuitem", tabindex: "-1", class: "pk-context-menu-item",
                data: { action: "click->phlex-kit--context-menu#close", phlex_kit__context_menu_target: "menuItem", disabled: @disabled } }, @attrs)) do
        if @checked
          span(class: "pk-context-menu-check") do
            render Icon.new(:check, size: 15)
          end
        end
        yield
        span(class: "pk-context-menu-shortcut") { @shortcut } if @shortcut
      end
    end
  end
end
