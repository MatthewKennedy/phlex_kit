module PhlexKit
  # Scrollable option list in a PhlexKit::ComboboxPopover. Carries the listbox
  # role and an id the controller points the combobox element's aria-controls
  # at (and derives option ids from). See combobox.rb.
  class ComboboxList < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        id: "pk-combobox-list-#{SecureRandom.hex(4)}",
        class: "pk-combobox-list",
        role: "listbox",
        data: { phlex_kit__combobox_target: "list" }
      }, @attrs), &)
    end
  end
end
