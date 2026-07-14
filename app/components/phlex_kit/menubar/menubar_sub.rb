module PhlexKit
  # Nested submenu wrapper: SubTrigger row + SubContent panel, revealed on
  # hover/focus with pure CSS. Mirrors shadcn/ui's MenubarSub. See menubar.rb.
  class MenubarSub < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      # syncSub mirrors the CSS-driven open state (:hover / :focus-within)
      # onto the sub trigger's aria-expanded.
      div(**mix({
        class: "pk-menubar-sub",
        data: { action: "mouseenter->phlex-kit--menubar#syncSub mouseleave->phlex-kit--menubar#syncSub focusin->phlex-kit--menubar#syncSub focusout->phlex-kit--menubar#syncSub" }
      }, @attrs), &)
    end
  end
end
