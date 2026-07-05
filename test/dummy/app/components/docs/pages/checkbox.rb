# frozen_string_literal: true

module Docs
  module Pages
    class Checkbox < Docs::BasePage
      self.description = "A control that allows the user to toggle between checked and not checked."

      def demos
        demo Docs::Examples::Checkbox::Basic, title: "Basic"
        demo Docs::Examples::Checkbox::Description, title: "Description"
        demo Docs::Examples::Checkbox::Disabled, title: "Disabled"
        demo Docs::Examples::Checkbox::Invalid, title: "Invalid"
        demo Docs::Examples::Checkbox::Group, title: "Group"
        demo Docs::Examples::Checkbox::InTable, title: "Table"
      end
    end
  end
end
