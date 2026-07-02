module PhlexKit
  class MessageContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-message-content", data: { slot: "message-content" } }, @attrs), &)
  end
end
