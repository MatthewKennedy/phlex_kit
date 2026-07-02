module PhlexKit
  # A selectable row in a PhlexKit::Select panel. Carries its `value:` in data-value; on
  # click/enter the controller copies it into the hidden SelectInput, updates the
  # SelectValue text, and flips `aria-selected` (which reveals the checkmark).
  # Pass `selected: true` to mark the initially-chosen item server-side — it's a
  # named kwarg (not an `"aria-selected":` attr) because `mix` would *merge* a
  # repeated attribute rather than override it.
  # See select.rb.
  class SelectItem < BaseComponent
    def initialize(value: nil, selected: false, **attrs)
      @value = value
      @selected = selected
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        role: "option",
        tabindex: "0",
        class: "pk-select-item",
        "aria-selected": (@selected ? "true" : "false"),
        data: {
          value: @value,
          controller: "phlex-kit--select-item",
          action: "click->phlex-kit--select#selectItem keydown.enter->phlex-kit--select#selectItem " \
                  "keydown.down->phlex-kit--select#handleKeyDown keydown.up->phlex-kit--select#handleKeyUp " \
                  "keydown.esc->phlex-kit--select#handleEsc",
          phlex_kit__select_target: "item"
        }
      }, @attrs)) do
        check_icon
        block&.call
      end
    end

    private

    def check_icon
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "pk-select-item-check",
        "aria-hidden": "true"
      ) { |s| s.path(d: "M20 6 9 17l-5-5") }
    end
  end
end
