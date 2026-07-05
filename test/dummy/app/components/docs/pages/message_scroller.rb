# frozen_string_literal: true

module Docs
  module Pages
    class MessageScroller < Docs::BasePage
      self.title = "Message Scroller"
      self.description = "A chat transcript pinned to the newest message; scroll up to unpin."

      def demos
        demo Docs::Examples::MessageScroller::Default, title: "Default"
        demo Docs::Examples::MessageScroller::Streaming, title: "Following the Live Edge"
        demo Docs::Examples::MessageScroller::Anchoring, title: "Anchoring Turns"
        demo Docs::Examples::MessageScroller::LoadHistory, title: "Load History"
        demo Docs::Examples::MessageScroller::OpeningPosition, title: "Opening Position"
      end
    end
  end
end
