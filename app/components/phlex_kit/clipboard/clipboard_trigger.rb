module PhlexKit
  class ClipboardTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-clipboard-trigger", data: { action: "click->phlex-kit--clipboard#copy" } }, @attrs), &)
  end
end
