# frozen_string_literal: true

module Docs
  module Pages
    class Label < Docs::BasePage
      self.description = "Renders an accessible label associated with controls."
      def demos
        demo Docs::Examples::Label::Default, title: "Default"
      end
    end
  end
end
