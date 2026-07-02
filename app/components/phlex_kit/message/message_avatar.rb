module PhlexKit
  class MessageAvatar < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-message-avatar", data: { slot: "message-avatar" } }, @attrs), &)
  end
end
