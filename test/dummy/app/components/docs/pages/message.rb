# frozen_string_literal: true

module Docs
  module Pages
    class Message < Docs::BasePage
      self.description = "Chat message rows with avatars, headers and bubbles."
      def demos
        demo Docs::Examples::Message::Conversation, title: "Conversation"
      end
    end
  end
end
