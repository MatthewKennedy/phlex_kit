module PhlexKit
  # Chat message row (avatar + content), ported from ruby_ui's RubyUI::Message.
  # align: :end reverses the row. Compose Message > MessageContent (+ Avatar/
  # Header/Footer); group several in a MessageGroup.
  class Message < BaseComponent
    def initialize(align: :start, **attrs)
      @align = align.to_sym
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-message", data: { slot: "message", align: @align } }, @attrs), &)
    end
  end
end
