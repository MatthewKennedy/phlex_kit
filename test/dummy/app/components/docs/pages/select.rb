# frozen_string_literal: true

module Docs
  module Pages
    class Select < Docs::BasePage
      self.description = "Displays a list of options for the user to pick from — triggered by a button."
      def demos
        demo Docs::Examples::Select::Default, title: "Default"
      end
    end
  end
end
