module PhlexKit
  # Height-constrained chat transcript with autoscroll/anchoring. Ported from
  # ruby_ui's RubyUI::MessageScroller. Mark the scroll viewport, content list, and
  # jump button inside with data-phlex-kit--message-scroller-target attributes.
  class MessageScroller < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-message-scroller", data: { controller: "phlex-kit--message-scroller", slot: "message-scroller" } }, @attrs), &)
    end
  end
end
