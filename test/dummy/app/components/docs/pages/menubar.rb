# frozen_string_literal: true

module Docs
  module Pages
    class Menubar < Docs::BasePage
      self.description = "A visually persistent menu common in desktop applications."

      def demos
        demo Docs::Examples::Menubar::Default, title: "Default"
        demo Docs::Examples::Menubar::Checkbox, title: "Checkbox"
        demo Docs::Examples::Menubar::Radio, title: "Radio"
        demo Docs::Examples::Menubar::Submenu, title: "Submenu"
        demo Docs::Examples::Menubar::WithIcons, title: "With Icons"
      end
    end
  end
end
