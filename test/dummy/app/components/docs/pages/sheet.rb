# frozen_string_literal: true

module Docs
  module Pages
    class Sheet < Docs::BasePage
      self.description = "Extends the Dialog to display content that complements the main screen."
      def demos
        demo Docs::Examples::Sheet::Default, title: "Side panel"
      end
    end
  end
end
