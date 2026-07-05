# frozen_string_literal: true

module Docs
  module Pages
    class Skeleton < Docs::BasePage
      self.description = "Use to show a placeholder while content is loading."

      def demos
        demo Docs::Examples::Skeleton::Default, title: "Avatar"
        demo Docs::Examples::Skeleton::Card, title: "Card"
        demo Docs::Examples::Skeleton::Text, title: "Text"
        demo Docs::Examples::Skeleton::Form, title: "Form"
        demo Docs::Examples::Skeleton::Table, title: "Table"
      end
    end
  end
end
