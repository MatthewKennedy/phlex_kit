module PhlexKit
  # Filter input at the top of a PhlexKit::ComboboxPopover (magnifier icon +
  # borderless search field). Filtering happens client-side against each item's
  # text (or data-text). The field carries the ARIA combobox role (keyboard nav
  # highlights options via aria-activedescendant while focus stays here); pass
  # `list_id:` matching the ComboboxList id to wire aria-controls statically —
  # otherwise the controller wires it on connect. See combobox.rb.
  class ComboboxSearchInput < BaseComponent
    def initialize(placeholder:, list_id: nil, **attrs)
      @placeholder = placeholder
      @list_id = list_id
      @attrs = attrs
    end

    def view_template
      div(class: "pk-combobox-search") do
        icon
        input(**mix({
          type: :search,
          role: "combobox",
          aria: { autocomplete: "list", expanded: "false", controls: @list_id },
          autocorrect: "off",
          autocomplete: "off",
          spellcheck: "false",
          placeholder: @placeholder,
          class: "pk-combobox-search-input",
          data: {
            phlex_kit__combobox_target: "searchInput",
            action: "keyup->phlex-kit--combobox#filterItems search->phlex-kit--combobox#filterItems"
          }
        }, @attrs))
      end
    end

    private

    def icon
      render Icon.new(:search, size: nil, class: "pk-combobox-search-icon")
    end
  end
end
