# frozen_string_literal: true

module Docs
  module Pages
    class Alert < Docs::BasePage
      self.description = "Displays a callout for user attention."

      def demos
        demo Docs::Examples::Alert::Basic, title: "Basic"
        demo Docs::Examples::Alert::Destructive, title: "Destructive"
        demo Docs::Examples::Alert::Action, title: "Action"
        demo Docs::Examples::Alert::CustomColors, title: "Custom Colors"
      end
    end
  end
end
