module PhlexKit
  class SheetContent < BaseComponent
    SIDES = { top: "top", right: "right", bottom: "bottom", left: "left" }.freeze
    def initialize(side: :right, **attrs)
      @side = side.to_sym
      @attrs = attrs
    end
    def view_template(&block)
      template(data: { phlex_kit__sheet_target: "content" }) do
        div(data: { controller: "phlex-kit--sheet-content" }) do
          div(class: "pk-sheet-backdrop", data: { action: "click->phlex-kit--sheet-content#close" })
          div(**mix({ class: ["pk-sheet-content", SIDES.fetch(@side)].join(" ") }, @attrs)) do
            block&.call
            button(type: "button", class: "pk-overlay-close", data: { action: "click->phlex-kit--sheet-content#close" }) do
              render Icon.new(:x, size: 15)
              span(class: "pk-sr-only") { "Close" }
            end
          end
        end
      end
    end
  end
end
