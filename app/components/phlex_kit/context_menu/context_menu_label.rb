module PhlexKit
  class ContextMenuLabel < BaseComponent
    def initialize(inset: false, **attrs)
      @inset = inset
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: [ "pk-context-menu-label", (@inset ? "inset" : nil) ].compact.join(" ") }, @attrs), &)
    end
  end
end
