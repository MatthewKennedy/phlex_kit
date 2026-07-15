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
          div(**mix({ class: [ "pk-sheet-content", fetch_option(SIDES, @side, :side) ].join(" "), role: "dialog", aria: { modal: "true" }, tabindex: "-1", data: { phlex_kit__sheet_content_target: "panel" } }, @attrs)) do
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
