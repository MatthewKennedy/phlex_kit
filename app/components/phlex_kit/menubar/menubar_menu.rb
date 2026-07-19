module PhlexKit
  # One trigger+panel pair in a Menubar. See menubar.rb.
  class MenubarMenu < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-menubar-menu", data: { phlex_kit__menubar_target: "menu" } }
      # role="none": role="menubar" only allows menuitem children in the
      # accessibility tree — this layout wrapper must be presentational so
      # the tree flattens to menubar > menuitem (axe: required-children).
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "none" unless attr_set?(:role)
      div(**mix(base, @attrs), &)
    end
  end
end
