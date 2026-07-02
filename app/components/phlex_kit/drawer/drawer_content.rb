module PhlexKit
  # <template> holding the drawer overlay + bottom panel (cloned into <body>
  # on open, like SheetContent). See drawer.rb.
  class DrawerContent < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      template(data: { phlex_kit__sheet_target: "content" }) do
        div(data: { controller: "phlex-kit--sheet-content" }) do
          div(class: "pk-drawer-overlay", data: { action: "click->phlex-kit--sheet-content#close" })
          div(**mix({ class: "pk-drawer", role: "dialog", aria: { modal: "true" } }, @attrs)) do
            div(class: "pk-drawer-handle", aria: { hidden: "true" })
            yield if block
          end
        end
      end
    end
  end
end
