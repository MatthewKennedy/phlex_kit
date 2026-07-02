module PhlexKit
  class MessageFooter < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-message-footer", data: { slot: "message-footer" } }, @attrs), &)
  end
end
