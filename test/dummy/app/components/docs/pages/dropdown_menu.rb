# frozen_string_literal: true

module Docs
  module Pages
    class DropdownMenu < Docs::BasePage
      self.description = "Displays a menu to the user — such as a set of actions or functions — triggered by a button."
      def demos
        demo Docs::Examples::DropdownMenu::Default, title: "Basic"
        demo Docs::Examples::DropdownMenu::Submenu, title: "Submenu"
        demo Docs::Examples::DropdownMenu::Shortcuts, title: "Shortcuts"
        demo Docs::Examples::DropdownMenu::Checkboxes, title: "Checkboxes"
        demo Docs::Examples::DropdownMenu::RadioGroup, title: "Radio group"
        demo Docs::Examples::DropdownMenu::Destructive, title: "Destructive"
        demo Docs::Examples::DropdownMenu::Avatar, title: "Avatar"
      end
    end
  end
end
