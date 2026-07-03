# frozen_string_literal: true

module Docs
  module Pages
    class Card < Docs::BasePage
      self.description = "Displays a card with header, content, and footer."
      def demos
        demo Docs::Examples::Card::LoginForm, title: "Default"
        demo Docs::Examples::Card::Small, title: "Size"
        demo Docs::Examples::Card::Spacing, title: "Spacing"
        demo Docs::Examples::Card::EdgeToEdge, title: "Edge-to-edge content"
        demo Docs::Examples::Card::WithImage, title: "Image"
      end
    end
  end
end
