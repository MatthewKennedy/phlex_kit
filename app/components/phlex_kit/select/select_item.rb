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
        # Roving listbox pattern: options are focusable programmatically only
        # (focus() works on tabindex=-1), so Tab exits the widget instead of
        # walking every option.
        tabindex: "-1",
        class: "pk-select-item",
        "aria-selected": (@selected ? "true" : "false"),
        data: {
          value: @value,
          action: "click->phlex-kit--select#selectItem keydown.enter->phlex-kit--select#selectItem " \
                  "keydown.down->phlex-kit--select#handleKeyDown keydown.up->phlex-kit--select#handleKeyUp " \
                  "keydown.home->phlex-kit--select#handleHome keydown.end->phlex-kit--select#handleEnd " \
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
      render Icon.new(:check, size: nil, class: "pk-select-item-check")
    end
  end
end
