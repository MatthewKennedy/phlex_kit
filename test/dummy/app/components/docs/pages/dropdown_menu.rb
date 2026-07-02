# frozen_string_literal: true

module Docs
  module Pages
    class DropdownMenu < Docs::BasePage
      self.description = "Displays a menu of actions or links, opened by a button."
      def demos
        demo Docs::Examples::DropdownMenu::Default, title: "My account"
      end
    end
  end
end
