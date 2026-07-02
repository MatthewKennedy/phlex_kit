module PhlexKit
  class MessageHeader < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-message-header", data: { slot: "message-header" } }, @attrs), &)
  end
end
