# frozen_string_literal: true

module Docs
  module Pages
    class Switch < Docs::BasePage
      self.description = "A control that allows the user to toggle between checked and not checked."
      def demos
        demo Docs::Examples::Switch::Default, title: "Default"
      end
    end
  end
end
