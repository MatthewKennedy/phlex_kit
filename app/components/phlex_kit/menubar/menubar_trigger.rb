module PhlexKit
  # See menubar.rb.
  class MenubarTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = {
        type: :button,
        class: "pk-menubar-trigger",
        data: { action: "click->phlex-kit--menubar#toggle mouseenter->phlex-kit--menubar#switch" }
      }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menuitem" unless attr_set?(:role)
      base[:"aria-haspopup"] = "menu" unless aria_key_set?(:haspopup)
      base[:"aria-expanded"] = "false" unless aria_key_set?(:expanded)
      button(**mix(base, @attrs), &)
    end
  end
end
