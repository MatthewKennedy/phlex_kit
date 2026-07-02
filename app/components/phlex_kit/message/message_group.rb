module PhlexKit
  class MessageGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-message-group", data: { slot: "message-group" } }, @attrs), &)
  end
end
