# frozen_string_literal: true

module Docs
  module Pages
    class Textarea < Docs::BasePage
      self.description = "Displays a form textarea or a component that looks like a textarea."

      def demos
        demo Docs::Examples::Textarea::Default, title: "Default"
        demo Docs::Examples::Textarea::Disabled, title: "Disabled"
        demo Docs::Examples::Textarea::Invalid, title: "Invalid"
        demo Docs::Examples::Textarea::WithButton, title: "Button"
      end
    end
  end
end
