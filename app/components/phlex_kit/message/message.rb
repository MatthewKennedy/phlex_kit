module PhlexKit
  # Chat message row (avatar + content), ported from ruby_ui's RubyUI::Message.
  # align: :end reverses the row. Compose Message > MessageContent (+ Avatar/
  # Header/Footer); group several in a MessageGroup.
  class Message < BaseComponent
    ALIGNS = %i[start end].freeze

    def initialize(align: :start, **attrs)
      @align = align.to_sym
      # Fail loud like sibling Bubble: message.css only styles data-align="end",
      # so an unknown value silently rendered a start-aligned row.
      raise KeyError, "unknown Message align #{@align}" unless ALIGNS.include?(@align)
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ class: "pk-message", data: { slot: "message", align: @align } }, @attrs), &)
    end
  end
end
