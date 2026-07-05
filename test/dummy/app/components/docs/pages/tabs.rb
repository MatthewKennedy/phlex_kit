# frozen_string_literal: true

module Docs
  module Pages
    class Tabs < Docs::BasePage
      self.description = "A set of layered sections of content displayed one at a time."

      def demos
        demo Docs::Examples::Tabs::Default, title: "Default"
        demo Docs::Examples::Tabs::Line, title: "Line"
        demo Docs::Examples::Tabs::Vertical, title: "Vertical"
        demo Docs::Examples::Tabs::Disabled, title: "Disabled"
        demo Docs::Examples::Tabs::Icons, title: "Icons"
      end
    end
  end
end
