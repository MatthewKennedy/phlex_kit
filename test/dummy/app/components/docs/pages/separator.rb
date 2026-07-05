# frozen_string_literal: true

module Docs
  module Pages
    class Separator < Docs::BasePage
      self.description = "Visually or semantically separates content."

      def demos
        demo Docs::Examples::Separator::Default, title: "Default"
        demo Docs::Examples::Separator::Vertical, title: "Vertical"
        demo Docs::Examples::Separator::Menu, title: "Menu"
        demo Docs::Examples::Separator::List, title: "List"
      end
    end
  end
end
