module PhlexKit
  class SheetContent < BaseComponent
    SIDES = { top: "top", right: "right", bottom: "bottom", left: "left" }.freeze

    def initialize(side: :right, show_close_button: true, **attrs)
      @side = side.to_sym
      @show_close_button = show_close_button
      @attrs = attrs
    end
    def view_template(&block)
      template(data: { phlex_kit__sheet_target: "content" }) do
        # data-pk-overlay-clone is a common marker read by other clone-based
        # overlays (see alert_dialog_controller.js#topmost) to determine
        # z-stacking across overlay families when they nest.
        div(data: { controller: "phlex-kit--sheet-content", action: "keydown->phlex-kit--sheet-content#keydown", pk_overlay_clone: "" }) do
          div(class: "pk-sheet-backdrop", data: { action: "click->phlex-kit--sheet-content#close mousedown->phlex-kit--sheet-content#overlayMousedown" })
          panel_attrs = { class: [ "pk-sheet-content", fetch_option(SIDES, @side, :side) ].join(" "), data: { phlex_kit__sheet_content_target: "panel" } }
          # Defaults only when the caller didn't supply their own — `mix`
          # would fuse role="dialog region" / aria-modal="true false" /
          # tabindex="-1 0" instead of overriding.
          panel_attrs[:role] = "dialog" unless attr_set?(:role)
          panel_attrs[:aria] = { modal: "true" } unless aria_key_set?(:modal)
          panel_attrs[:tabindex] = "-1" unless attr_set?(:tabindex)
          div(**mix(panel_attrs, @attrs)) do
            block&.call
            if @show_close_button
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
end
