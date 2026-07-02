# frozen_string_literal: true

module Docs
  module Pages
    class NavigationMenu < Docs::BasePage
      self.description = "A collection of links for navigating websites, with hoverable panels."
      def demos
        demo Docs::Examples::NavigationMenu::Default, title: "Default"
      end
    end
  end
end
