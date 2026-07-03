# frozen_string_literal: true

module Docs
  module Pages
    class Sidebar < Docs::BasePage
      self.description = "A composable sidebar rail — this site's own menu is built with it."
      def demos
        demo Docs::Examples::Sidebar::Default, title: "Default"
        demo Docs::Examples::Sidebar::SolidMenu, title: "Solid menu"
      end
    end
  end
end
