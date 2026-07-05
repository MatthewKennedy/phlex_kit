# frozen_string_literal: true

module Docs
  module Pages
    class Select < Docs::BasePage
      self.description = "Displays a list of options for the user to pick from — triggered by a button."

      def demos
        demo Docs::Examples::Select::Default, title: "Default"
        demo Docs::Examples::Select::Groups, title: "Groups"
        demo Docs::Examples::Select::Scrollable, title: "Scrollable"
        demo Docs::Examples::Select::Disabled, title: "Disabled"
        demo Docs::Examples::Select::Invalid, title: "Invalid"
      end
    end
  end
end
