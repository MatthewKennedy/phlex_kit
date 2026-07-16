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
        div(data: { controller: "phlex-kit--sheet-content", action: "keydown->phlex-kit--sheet-content#keydown", pk_overlay_clone: "" }) do
          div(class: "pk-drawer-overlay", data: { action: "click->phlex-kit--sheet-content#close mousedown->phlex-kit--sheet-content#overlayMousedown" })
          panel_attrs = { class: "pk-drawer #{fetch_option(SIDES, @side, :side)}", data: { phlex_kit__sheet_content_target: "panel" } }
          # Defaults only when the caller didn't supply their own — `mix`
          # would fuse role="dialog region" / aria-modal="true false" /
          # tabindex="-1 0" instead of overriding.
          panel_attrs[:role] = "dialog" unless attr_set?(:role)
          panel_attrs[:aria] = { modal: "true" } unless aria_key_set?(:modal)
          panel_attrs[:tabindex] = "-1" unless attr_set?(:tabindex)
          div(**mix(panel_attrs, @attrs)) do
            div(class: "pk-drawer-handle", aria: { hidden: "true" })
            yield if block
          end
        end
      end
    end
  end
end
