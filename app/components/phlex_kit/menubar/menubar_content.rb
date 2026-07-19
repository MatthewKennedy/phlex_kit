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
      base = { id: @id, class: "pk-menubar-content" }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:popover] = "manual" unless attr_set?(:popover)
      base[:role] = "menu" unless attr_set?(:role)
      div(**mix(base, @attrs), &)
    end
  end
end
