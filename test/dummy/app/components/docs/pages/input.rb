# frozen_string_literal: true

module Docs
  module Pages
    class Input < Docs::BasePage
      self.description = "Displays a form input field or a component that looks like an input field."
      def demos
        demo Docs::Examples::Input::Default, title: "Default"
        demo Docs::Examples::Input::Types, title: "Types & states"
      end
    end
  end
end
