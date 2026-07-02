module PhlexKit
  # One trigger+panel pair in a Menubar. See menubar.rb.
  class MenubarMenu < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-menubar-menu", data: { phlex_kit__menubar_target: "menu" } }, @attrs), &)
    end
  end
end
