module PhlexKit
  # One trigger+panel pair in a Menubar. See menubar.rb.
  class MenubarMenu < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      # role="none": role="menubar" only allows menuitem children in the
      # accessibility tree — this layout wrapper must be presentational so
      # the tree flattens to menubar > menuitem (axe: required-children).
      div(**mix({ class: "pk-menubar-menu", role: "none", data: { phlex_kit__menubar_target: "menu" } }, @attrs), &)
    end
  end
end
