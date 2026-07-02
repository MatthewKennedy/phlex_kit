# frozen_string_literal: true

module Docs
  module Pages
    class Card < Docs::BasePage
      self.description = "Displays a card with header, content, and footer."
      def demos
        demo Docs::Examples::Card::LoginForm, title: "Login form"
      end
    end
  end
end
