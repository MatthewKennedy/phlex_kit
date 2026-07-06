module PhlexKit
  # <template> holding the drawer overlay + panel (cloned into <body> on open,
  # like SheetContent). `side:` picks the attached edge — :bottom (default),
  # :top, :left or :right, matching shadcn's direction prop. See drawer.rb.
  class DrawerContent < BaseComponent
    SIDES = { bottom: "bottom", top: "top", left: "left", right: "right" }.freeze

    def initialize(side: :bottom, **attrs)
      @side = side.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      template(data: { phlex_kit__sheet_target: "content" }) do
        div(data: { controller: "phlex-kit--sheet-content", action: "keydown->phlex-kit--sheet-content#keydown" }) do
          div(class: "pk-drawer-overlay", data: { action: "click->phlex-kit--sheet-content#close" })
          div(**mix({ class: "pk-drawer #{SIDES.fetch(@side)}", role: "dialog", aria: { modal: "true" }, tabindex: "-1", data: { phlex_kit__sheet_content_target: "panel" } }, @attrs)) do
            div(class: "pk-drawer-handle", aria: { hidden: "true" })
            yield if block
          end
        end
      end
    end
  end
end
