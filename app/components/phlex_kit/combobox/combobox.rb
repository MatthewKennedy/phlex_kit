module PhlexKit
  # Combobox (searchable multi/single select), ported from ruby_ui's
  # RubyUI::Combobox. Selection state lives in real checkbox/radio inputs, so the
  # value submits with the form; the trigger label, filtering, keyboard nav and
  # toggle-all live in the phlex-kit--combobox controller. Like PhlexKit::Select, the
  # @floating-ui/dom + native-popover positioning is replaced with CSS (panel
  # anchored below the trigger, click-outside via window action). Compose
  # Combobox(term:) > Trigger + Popover(SearchInput + List(ListGroup >
  # Item(Checkbox|Radio + text + ItemIndicator)) + EmptyState [+
  # ToggleAllCheckbox]). ruby_ui's unreleased input/badge trigger variants
  # (no controller support upstream) are deliberately not ported. Tailwind →
  # vanilla `.pk-combobox*` (combobox.css).
  class Combobox < BaseComponent
    def initialize(term: nil, **attrs)
      @term = term
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        role: "combobox",
        class: "pk-combobox",
        data: {
          controller: "phlex-kit--combobox",
          phlex_kit__combobox_term_value: @term,
          action: "turbo:morph@window->phlex-kit--combobox#updateTriggerContent click@window->phlex-kit--combobox#onClickOutside"
        }
      }, @attrs), &)
    end
  end
end
