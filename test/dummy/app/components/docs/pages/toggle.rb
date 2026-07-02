# frozen_string_literal: true

module Docs
  module Pages
    class Toggle < Docs::BasePage
      self.description = "A two-state button that can be either on or off."
      def demos
        demo Docs::Examples::Toggle::Default, title: "Default"
      end
    end
  end
end
