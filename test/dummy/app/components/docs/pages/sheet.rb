# frozen_string_literal: true

module Docs
  module Pages
    class Sheet < Docs::BasePage
      self.description = "Extends the Dialog component to display content that complements the main content of the screen."

      def demos
        demo Docs::Examples::Sheet::Default, title: "Default"
        demo Docs::Examples::Sheet::Side, title: "Side"
        demo Docs::Examples::Sheet::NoCloseButton, title: "No Close Button"
        demo Docs::Examples::Sheet::WithNestedDialog, title: "With Nested Dialog"
        demo Docs::Examples::Sheet::WithNestedMenu, title: "With Nested Menu"
      end
    end
  end
end
