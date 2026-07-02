# frozen_string_literal: true

module Docs
  module Pages
    class Menubar < Docs::BasePage
      self.description = "A visually persistent menu common in desktop applications."
      def demos
        demo Docs::Examples::Menubar::Default, title: "Default"
      end
    end
  end
end
