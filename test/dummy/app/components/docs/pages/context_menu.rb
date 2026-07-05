# frozen_string_literal: true

module Docs
  module Pages
    class ContextMenu < Docs::BasePage
      self.description = "Displays a menu at the pointer, triggered by right-click."

      def demos
        demo Docs::Examples::ContextMenu::Basic, title: "Basic"
        demo Docs::Examples::ContextMenu::Submenu, title: "Submenu"
        demo Docs::Examples::ContextMenu::Shortcuts, title: "Shortcuts"
        demo Docs::Examples::ContextMenu::Groups, title: "Groups"
        demo Docs::Examples::ContextMenu::Icons, title: "Icons"
        demo Docs::Examples::ContextMenu::Checkboxes, title: "Checkboxes"
        demo Docs::Examples::ContextMenu::Radio, title: "Radio"
        demo Docs::Examples::ContextMenu::Destructive, title: "Destructive"
      end
    end
  end
end
