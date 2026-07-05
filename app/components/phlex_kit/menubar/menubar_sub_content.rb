module PhlexKit
  # The nested panel of a MenubarSub — opens beside the trigger. See menubar.rb.
  class MenubarSubContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-menubar-sub-content", role: "menu" }, @attrs)) do
        div(class: "pk-menubar-sub-viewport", &)
      end
    end
  end
end
