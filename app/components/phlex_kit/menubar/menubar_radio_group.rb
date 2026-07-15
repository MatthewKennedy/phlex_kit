module PhlexKit
  # Exclusive-choice group of MenubarRadioItems (share the same `name:`).
  # Mirrors shadcn/ui's MenubarRadioGroup. role="group" (NOT "radiogroup"):
  # radiogroup may not own menuitemradio children (axe aria-required-children).
  # See menubar.rb.
  class MenubarRadioGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-menubar-group", role: "group" }, @attrs), &)
    end
  end
end
