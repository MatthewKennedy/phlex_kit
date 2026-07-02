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
    def initialize(placeholder: "", clear_button: false, **attrs)
      @placeholder = placeholder
      @clear_button = clear_button
      @attrs = attrs
    end

    def view_template
      div(**mix({
        class: "pk-combobox-badge-trigger",
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
        div(class: "pk-combobox-badge-container pk-hidden", data: { phlex_kit__combobox_target: "badgeContainer" })
        input(
          type: :text,
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
              "keydown.backspace->phlex-kit--combobox#handleBadgeInputBackspace"
            ].join(" ")
          }
        )
        render ComboboxClearButton.new if @clear_button
      end
    end
  end
end
