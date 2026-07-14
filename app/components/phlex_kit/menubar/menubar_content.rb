module PhlexKit
  # Dropdown panel of a MenubarMenu. See menubar.rb.
  class MenubarContent < BaseComponent
    def initialize(**attrs)
      # Default id so the controller can wire the trigger's aria-controls to
      # this panel in menuTargetConnected (same pattern as accordion).
      @id = attrs.delete(:id) || "pk-menubar-content-#{SecureRandom.hex(4)}"
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ id: @id, class: "pk-menubar-content", popover: "manual", role: "menu" }, @attrs), &)
    end
  end
end
