# frozen_string_literal: true

module Docs
  module Pages
    class ButtonGroup < Docs::BasePage
      self.description = "Joins related buttons into one segmented control."
      def demos
        demo Docs::Examples::ButtonGroup::Default, title: "Default"
        demo Docs::Examples::ButtonGroup::WithInput, title: "Split action"
      end
    end
  end
end
