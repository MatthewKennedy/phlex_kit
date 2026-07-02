# frozen_string_literal: true

module Docs
  module Pages
    class ContextMenu < Docs::BasePage
      self.description = "Displays a menu at the pointer, triggered by right-click."
      def demos
        demo Docs::Examples::ContextMenu::Default, title: "Default"
      end
    end
  end
end
