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
            svg(width: "15", height: "15", viewbox: "0 0 15 15", fill: "none", xmlns: "http://www.w3.org/2000/svg") do |s|
              s.path(fill_rule: "evenodd", clip_rule: "evenodd", fill: "currentColor", d: "M11.4669 3.72684C11.7558 3.91574 11.8369 4.30308 11.648 4.59198L7.39799 11.092C7.29783 11.2452 7.13556 11.3467 6.95402 11.3699C6.77247 11.3931 6.58989 11.3355 6.45446 11.2124L3.70446 8.71241C3.44905 8.48022 3.43023 8.08494 3.66242 7.82953C3.89461 7.57412 4.28989 7.55529 4.5453 7.78749L6.75292 9.79441L10.6018 3.90792C10.7907 3.61902 11.178 3.53795 11.4669 3.72684Z")
            end
          end
        end
        yield
        span(class: "pk-context-menu-shortcut") { @shortcut } if @shortcut
      end
    end
  end
end
