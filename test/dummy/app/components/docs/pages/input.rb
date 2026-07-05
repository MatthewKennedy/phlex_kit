# frozen_string_literal: true

module Docs
  module Pages
    class Input < Docs::BasePage
      self.description = "Displays a form input field or a component that looks like an input field."

      def demos
        demo Docs::Examples::Input::Basic, title: "Basic"
        demo Docs::Examples::Input::Disabled, title: "Disabled"
        demo Docs::Examples::Input::Invalid, title: "Invalid"
        demo Docs::Examples::Input::File, title: "File"
        demo Docs::Examples::Input::Inline, title: "Inline"
        demo Docs::Examples::Input::Grid, title: "Grid"
        demo Docs::Examples::Input::Required, title: "Required"
        demo Docs::Examples::Input::WithBadge, title: "Badge"
      end
    end
  end
end
