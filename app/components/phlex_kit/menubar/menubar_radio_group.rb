module PhlexKit
  # Exclusive-choice group of MenubarRadioItems (share the same `name:`).
  # Mirrors shadcn/ui's MenubarRadioGroup. See menubar.rb.
  class MenubarRadioGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-menubar-group", role: "radiogroup" }, @attrs), &)
    end
  end
end
