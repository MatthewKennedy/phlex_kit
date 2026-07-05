# frozen_string_literal: true

module Docs
  module Pages
    class Toggle < Docs::BasePage
      self.description = "A two-state button that can be either on or off."

      def demos
        demo Docs::Examples::Toggle::Default, title: "Default"
        demo Docs::Examples::Toggle::Outline, title: "Outline"
        demo Docs::Examples::Toggle::WithText, title: "With Text"
        demo Docs::Examples::Toggle::Sizes, title: "Size"
        demo Docs::Examples::Toggle::Disabled, title: "Disabled"
      end
    end
  end
end
