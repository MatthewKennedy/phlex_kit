module PhlexKit
  # See menubar.rb.
  class MenubarTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      button(**mix({
        type: :button,
        class: "pk-menubar-trigger",
        aria: { haspopup: "menu", expanded: "false" },
        data: { action: "click->phlex-kit--menubar#toggle mouseenter->phlex-kit--menubar#switch" }
      }, @attrs), &)
    end
  end
end
