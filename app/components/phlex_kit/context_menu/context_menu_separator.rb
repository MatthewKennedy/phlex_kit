module PhlexKit
  class ContextMenuSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      div(**mix({ role: "separator", class: "pk-context-menu-separator", aria: { orientation: "horizontal" } }, @attrs))
    end
  end
end
