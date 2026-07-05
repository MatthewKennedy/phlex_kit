# frozen_string_literal: true

module Docs
  module Pages
    class Tooltip < Docs::BasePage
      self.description = "A popup that displays information related to an element on hover or focus."

      def demos
        demo Docs::Examples::Tooltip::Default, title: "Default"
        demo Docs::Examples::Tooltip::Sides, title: "Side"
        demo Docs::Examples::Tooltip::WithKbd, title: "With Keyboard Shortcut"
        demo Docs::Examples::Tooltip::DisabledButton, title: "Disabled Button"
      end
    end
  end
end
