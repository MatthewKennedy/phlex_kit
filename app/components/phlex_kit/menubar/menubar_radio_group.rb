module PhlexKit
  # Exclusive-choice group of MenubarRadioItems (share the same `name:`).
  # Mirrors shadcn/ui's MenubarRadioGroup. role="group" (NOT "radiogroup"):
  # radiogroup may not own menuitemradio children (axe aria-required-children).
  # See menubar.rb.
  class MenubarRadioGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-menubar-group" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "group" unless attr_set?(:role)
      div(**mix(base, @attrs), &)
    end
  end
end
