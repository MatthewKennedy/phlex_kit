module PhlexKit
  # Single-field trigger for PhlexKit::Combobox — the input doubles as the filter
  # (autocomplete style): focusing or clicking opens the popover, typing
  # filters, arrows/enter pick, and the chosen option's text becomes the field
  # value. Ported from ruby_ui's RubyUI::ComboboxInputTrigger; upstream shipped
  # the markup without controller support, so the behaviour (open-on-focus,
  # keyboard nav from the field, selection reflection) is PhlexKit's completion
  # of it. Keyboard actions live here because focus stays in this field — the
  # popover's own bindings only fire for the button+search layout.
  # See combobox.rb.
  class ComboboxInputTrigger < BaseComponent
    def initialize(placeholder: "", **attrs)
      @placeholder = placeholder
      @attrs = attrs
    end

    def view_template
      div(**mix({
        class: "pk-combobox-input-trigger",
        aria: { haspopup: "listbox", expanded: "false" },
        data: {
          placeholder: @placeholder,
          phlex_kit__combobox_target: "trigger",
          action: [
            "click->phlex-kit--combobox#openPopover",
            "focusin->phlex-kit--combobox#openPopover",
            "keydown.down->phlex-kit--combobox#keyDownPressed",
            "keydown.up->phlex-kit--combobox#keyUpPressed",
            "keydown.enter->phlex-kit--combobox#keyEnterPressed",
            "keydown.esc->phlex-kit--combobox#closePopover:prevent"
          ].join(" ")
        }
      }, @attrs)) do
        input(
          type: :text,
          placeholder: @placeholder,
          autocomplete: "off",
          autocorrect: "off",
          spellcheck: "false",
          class: "pk-combobox-input-trigger-field",
          data: {
            phlex_kit__combobox_target: "inputTrigger",
            action: "keyup->phlex-kit--combobox#filterItems input->phlex-kit--combobox#filterItems"
          }
        )
        chevron_icon
      end
    end

    private

    def chevron_icon
      span(class: "pk-combobox-input-trigger-icon") do
        svg(
          xmlns: "http://www.w3.org/2000/svg",
          width: "24",
          height: "24",
          viewbox: "0 0 24 24",
          fill: "none",
          stroke: "currentColor",
          "stroke-width": "2",
          "stroke-linecap": "round",
          "stroke-linejoin": "round",
          "aria-hidden": "true"
        ) { |s| s.path(d: "m6 9 6 6 6-6") }
      end
    end
  end
end
