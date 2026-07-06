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
    def initialize(placeholder: "", disabled: false, invalid: false, list_id: nil, **attrs)
      @placeholder = placeholder
      @disabled = disabled
      @invalid = invalid
      @list_id = list_id
      @attrs = attrs
    end

    def view_template
      # The ARIA combobox role sits on the field itself (the interactive
      # element); the wrapper keeps aria-invalid only because the invalid
      # styling targets it. Pass `list_id:` matching the ComboboxList id to
      # wire aria-controls statically — otherwise the controller wires it.
      wrapper_aria = {}
      wrapper_aria[:invalid] = "true" if @invalid
      div(**mix({
        class: "pk-combobox-input-trigger",
        aria: wrapper_aria,
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
        field_aria = { haspopup: "listbox", expanded: "false", autocomplete: "list", controls: @list_id }
        field_aria[:invalid] = "true" if @invalid
        input(
          type: :text,
          role: "combobox",
          aria: field_aria,
          placeholder: @placeholder,
          disabled: @disabled,
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
        render Icon.new(:chevron_down, size: 24)
      end
    end
  end
end
