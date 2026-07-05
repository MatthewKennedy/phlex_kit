# frozen_string_literal: true

module Docs
  module Pages
    class Message < Docs::BasePage
      self.description = "Chat message rows with avatars, headers and bubbles."

      def demos
        demo Docs::Examples::Message::Conversation, title: "Conversation"
        demo Docs::Examples::Message::WithAvatar, title: "Avatar"
        demo Docs::Examples::Message::Group, title: "Group"
        demo Docs::Examples::Message::HeaderAndFooter, title: "Header and Footer"
        demo Docs::Examples::Message::Actions, title: "Actions"
        demo Docs::Examples::Message::WithAttachment, title: "Attachment"
      end
    end
  end
end
