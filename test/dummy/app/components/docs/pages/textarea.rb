# frozen_string_literal: true

module Docs
  module Pages
    class Textarea < Docs::BasePage
      self.description = "Displays a form textarea or a component that looks like a textarea."
      def demos
        demo Docs::Examples::Textarea::Default, title: "Default"
      end
    end
  end
end
