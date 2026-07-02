# frozen_string_literal: true

module Docs
  module Pages
    class Alert < Docs::BasePage
      self.description = "Displays a callout for user attention."

      def demos
        demo Docs::Examples::Alert::Default, title: "Default"
        demo Docs::Examples::Alert::Destructive, title: "Destructive"
      end
    end
  end
end
