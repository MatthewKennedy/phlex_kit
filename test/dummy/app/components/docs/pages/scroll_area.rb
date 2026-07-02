# frozen_string_literal: true

module Docs
  module Pages
    class ScrollArea < Docs::BasePage
      self.description = "Augments native scroll with themed thin scrollbars."
      def demos
        demo Docs::Examples::ScrollArea::Default, title: "Default"
      end
    end
  end
end
