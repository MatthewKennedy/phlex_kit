module PhlexKit
  # Search field at the top of a PhlexKit::Command — filters the items as you
  # type, arrows/enter drive selection, esc dismisses. See command.rb.
  class CommandInput < BaseComponent
    def initialize(placeholder: "Type a command or search...", **attrs)
      @placeholder = placeholder
      @attrs = attrs
    end

    def view_template
      div(class: "pk-command-input-row") do
        search_icon
        input(**mix({
          type: :text,
          class: "pk-command-input",
          placeholder: @placeholder,
          autocomplete: "off",
          autocorrect: "off",
          spellcheck: "false",
          autofocus: true,
          role: "combobox",
          value: "",
          aria: { autocomplete: "list", expanded: "true" },
          data: {
            phlex_kit__command_target: "input",
            action: [
              "input->phlex-kit--command#filter",
              "keydown.down->phlex-kit--command#handleKeydown",
              "keydown.up->phlex-kit--command#handleKeydown",
              "keydown.enter->phlex-kit--command#handleKeydown",
              "keydown.esc->phlex-kit--command#dismiss"
            ].join(" ")
          }
        }, @attrs))
      end
    end

    private

    def search_icon
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        viewbox: "0 0 20 20",
        fill: "currentColor",
        class: "pk-command-input-icon",
        "aria-hidden": "true"
      ) do |s|
        s.path(
          fill_rule: "evenodd",
          d: "M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z",
          clip_rule: "evenodd"
        )
      end
    end
  end
end
