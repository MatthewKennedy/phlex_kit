module PhlexKit
  # Grouping wrapper for related rows. Mirrors shadcn/ui's MenubarGroup.
  # See menubar.rb.
  class MenubarGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-menubar-group" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "group" unless attr_set?(:role)
      div(**mix(base, @attrs), &)
    end
  end
end
