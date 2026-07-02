module PhlexKit
  # Filter input at the top of a PhlexKit::ComboboxPopover (magnifier icon +
  # borderless search field). Filtering happens client-side against each item's
  # text (or data-text). See combobox.rb.
  class ComboboxSearchInput < BaseComponent
    def initialize(placeholder:, **attrs)
      @placeholder = placeholder
      @attrs = attrs
    end

    def view_template
      div(class: "pk-combobox-search") do
        icon
        input(**mix({
          type: :search,
          role: "searchbox",
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
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "pk-combobox-search-icon",
        "aria-hidden": "true"
      ) do |s|
        s.circle(cx: "11", cy: "11", r: "8")
        s.path(d: "m21 21-4.3-4.3")
      end
    end
  end
end
