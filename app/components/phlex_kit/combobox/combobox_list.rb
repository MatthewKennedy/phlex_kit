module PhlexKit
  # Scrollable option list in a PhlexKit::ComboboxPopover. Carries the listbox
  # role and an id the controller points the combobox element's aria-controls
  # at (and derives option ids from). See combobox.rb.
  class ComboboxList < BaseComponent
    # id: is a named kwarg (not left in **attrs) because `mix` would *merge* a
    # caller id with the generated one into an invalid two-token id, breaking
    # aria-controls (the documented list_id: wiring) and derived option ids.
    def initialize(id: nil, **attrs)
      @id = id || "pk-combobox-list-#{SecureRandom.hex(4)}"
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        id: @id,
        class: "pk-combobox-list",
        role: "listbox",
        data: { phlex_kit__combobox_target: "list" }
      }, @attrs), &)
    end
  end
end
