module PhlexKit
  # Search field at the top of a PhlexKit::Command — filters the items as you
  # type, arrows/enter drive selection, esc dismisses. Renders as shadcn's
  # current bordered pill inside the padded palette (input-wrapper >
  # input-group). See command.rb.
  # Pass `list_id:` matching the CommandList id to wire aria-controls
  # statically — otherwise the controller wires it on connect. aria-expanded
  # stays "true" because the list is always visible (filtering hides items,
  # never the listbox itself).
  class CommandInput < BaseComponent
    def initialize(placeholder: "Type a command or search...", list_id: nil, **attrs)
      @placeholder = placeholder
      @list_id = list_id
      @attrs = attrs
    end

    def view_template
      div(class: "pk-command-input-wrapper") do
        div(class: "pk-command-input-pill") do
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
            aria: { autocomplete: "list", expanded: "true", controls: @list_id },
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
    end

    private

    def search_icon
      render Icon.new(:search, size: nil, class: "pk-command-input-icon")
    end
  end
end
