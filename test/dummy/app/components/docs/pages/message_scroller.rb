# frozen_string_literal: true

module Docs
  module Pages
    class MessageScroller < Docs::BasePage
      self.description = "A chat transcript pinned to the newest message; scroll up to unpin."
      def demos
        demo Docs::Examples::MessageScroller::Default, title: "Default"
      end
    end
  end
end
