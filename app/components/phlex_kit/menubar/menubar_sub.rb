module PhlexKit
  # Nested submenu wrapper: SubTrigger row + SubContent panel, revealed on
  # hover/focus with pure CSS. Mirrors shadcn/ui's MenubarSub. See menubar.rb.
  class MenubarSub < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-menubar-sub" }, @attrs), &)
    end
  end
end
