# frozen_string_literal: true

module Docs
  module Pages
    class Combobox < Docs::BasePage
      self.description = "Autocomplete input and command palette with a list of suggestions."

      def demos
        demo Docs::Examples::Combobox::Basic, title: "Basic"
        demo Docs::Examples::Combobox::Multiple, title: "Multiple"
        demo Docs::Examples::Combobox::ClearButton, title: "Clear Button"
        demo Docs::Examples::Combobox::Groups, title: "Groups"
        demo Docs::Examples::Combobox::CustomItems, title: "Custom Items"
        demo Docs::Examples::Combobox::Invalid, title: "Invalid"
        demo Docs::Examples::Combobox::Disabled, title: "Disabled"
        demo Docs::Examples::Combobox::AutoHighlight, title: "Auto Highlight"
        demo Docs::Examples::Combobox::Popup, title: "Popup"
        demo Docs::Examples::Combobox::InInputGroup, title: "Input Group"
        demo Docs::Examples::Combobox::ButtonTrigger, title: "Multi-select with search"
      end
    end
  end
end
