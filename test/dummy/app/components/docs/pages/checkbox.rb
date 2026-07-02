# frozen_string_literal: true

module Docs
  module Pages
    class Checkbox < Docs::BasePage
      self.description = "A control that allows the user to toggle between checked and not checked."
      def demos
        demo Docs::Examples::Checkbox::Default, title: "With label"
        demo Docs::Examples::Checkbox::Disabled, title: "Disabled"
      end
    end
  end
end
