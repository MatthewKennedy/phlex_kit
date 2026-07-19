module PhlexKit
  # The nested panel of a MenubarSub — opens beside the trigger. See menubar.rb.
  class MenubarSubContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      base = { class: "pk-menubar-sub-content" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menu" unless attr_set?(:role)
      div(**mix(base, @attrs)) do
        div(class: "pk-menubar-sub-viewport", &)
      end
    end
  end
end
