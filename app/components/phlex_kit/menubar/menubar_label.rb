module PhlexKit
  # Non-interactive heading row in a MenubarContent. Mirrors shadcn/ui's
  # MenubarLabel. See menubar.rb.
  class MenubarLabel < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-menubar-label" }, @attrs), &)
    end
  end
end
