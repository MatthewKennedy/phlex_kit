# frozen_string_literal: true

module Docs
  module Pages
    class ScrollArea < Docs::BasePage
      self.description = "Augments native scroll with themed thin scrollbars."

      def demos
        demo Docs::Examples::ScrollArea::Default, title: "Default"
        demo Docs::Examples::ScrollArea::Horizontal, title: "Horizontal"
      end
    end
  end
end
