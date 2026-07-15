module PhlexKit
  # Multi-select trigger for PhlexKit::Combobox that shows each checked option as
  # a removable chip: the controller renders ComboboxBadge-style chips into the
  # badge container, backspace in the empty field removes the last one, and
  # `clear_button: true` adds a ComboboxClearButton. Ported from ruby_ui's
  # RubyUI::ComboboxBadgeTrigger; upstream shipped the markup without controller
  # support, so the badge rendering / backspace-removal / clear-all behaviour is
  # PhlexKit's completion of it. Keyboard actions live here because focus stays
  # in this field (see ComboboxInputTrigger). See combobox.rb.
  class ComboboxBadgeTrigger < BaseComponent
    def initialize(placeholder: "", clear_button: false, list_id: nil, **attrs)
      @placeholder = placeholder
      @clear_button = clear_button
      @list_id = list_id
      @attrs = attrs
    end

    def view_template
      # The ARIA combobox role sits on the field itself (the interactive
      # element), not this wrapper. Pass `list_id:` matching the ComboboxList
      # id to wire aria-controls statically — otherwise the controller wires it.
      div(**mix({
        class: "pk-combobox-badge-trigger",
        data: {
          placeholder: @placeholder,
          phlex_kit__combobox_target: "trigger",
          action: [
            "click->phlex-kit--combobox#openPopover",
            "focusin->phlex-kit--combobox#openPopover",
            "keydown.down->phlex-kit--combobox#keyDownPressed",
            "keydown.up->phlex-kit--combobox#keyUpPressed",
            "keydown.enter->phlex-kit--combobox#keyEnterPressed",
            # no :prevent — closePopover only swallows Escape while open.
            "keydown.esc->phlex-kit--combobox#closePopover"
          ].join(" ")
        }
      }, @attrs)) do
        div(class: "pk-combobox-badge-container pk-hidden", data: { phlex_kit__combobox_target: "badgeContainer" })
        input(
          type: :text,
          role: "combobox",
          aria: { haspopup: "listbox", expanded: "false", autocomplete: "list", controls: @list_id },
          placeholder: @placeholder,
          autocomplete: "off",
          autocorrect: "off",
          spellcheck: "false",
          class: "pk-combobox-badge-input",
          data: {
            phlex_kit__combobox_target: "badgeInput",
            action: [
              "keyup->phlex-kit--combobox#filterItems",
              "input->phlex-kit--combobox#filterItems",
              # plain keydown — "backspace" is not a Stimulus key filter
              # (using it throws "unknown key filter" on every keystroke and
              # the handler never ran); the method guards on e.key itself.
              "keydown->phlex-kit--combobox#handleBadgeInputBackspace"
            ].join(" ")
          }
        )
        render ComboboxClearButton.new if @clear_button
      end
    end
  end
end
