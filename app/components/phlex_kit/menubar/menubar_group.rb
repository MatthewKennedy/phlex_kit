module PhlexKit
  # Grouping wrapper for related rows. Mirrors shadcn/ui's MenubarGroup.
  # See menubar.rb.
  class MenubarGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-menubar-group", role: "group" }, @attrs), &)
    end
  end
end
