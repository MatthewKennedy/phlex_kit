module PhlexKit
  # One choice in a MenubarRadioGroup — a <label> around a real (hidden)
  # radio; the ● shows via CSS and picking doesn't close the menu (matching
  # Radix). See menubar.rb.
  class MenubarRadioItem < BaseComponent
    def initialize(name:, value:, checked: false, **attrs)
      @name = name
      @value = value
      @checked = checked
      @attrs = attrs
    end

    def view_template(&block)
      label(**mix({
        class: "pk-menubar-item pk-menubar-radio-item",
        role: "menuitemradio"
      }, @attrs)) do
        input(type: :radio, class: "pk-menubar-item-input", name: @name, value: @value, checked: @checked)
        span(class: "pk-menubar-item-indicator", aria: { hidden: "true" }) do
          # A filled selection dot is geometry, not icon-library vocabulary.
          svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "currentColor") do |s|
            s.circle(cx: "12", cy: "12", r: "5")
          end
        end
        yield if block
      end
    end
  end
end
