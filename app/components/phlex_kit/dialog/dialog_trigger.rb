module PhlexKit
  class DialogTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-dialog-trigger", data: { action: "click->phlex-kit--dialog#open" } }, @attrs), &)
    end
  end
end
