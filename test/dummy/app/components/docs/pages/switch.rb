# frozen_string_literal: true

module Docs
  module Pages
    class Switch < Docs::BasePage
      self.description = "A control that allows the user to toggle between checked and not checked."

      def demos
        demo Docs::Examples::Switch::Default, title: "Default"
        demo Docs::Examples::Switch::Description, title: "Description"
        demo Docs::Examples::Switch::ChoiceCard, title: "Choice Card"
        demo Docs::Examples::Switch::Disabled, title: "Disabled"
        demo Docs::Examples::Switch::Invalid, title: "Invalid"
        demo Docs::Examples::Switch::Size, title: "Size"
      end
    end
  end
end
