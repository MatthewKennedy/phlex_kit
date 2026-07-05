# frozen_string_literal: true

module Docs
  module Pages
    class Drawer < Docs::BasePage
      self.description = "A bottom sheet with sides — vaul replaced by the kit's clone machinery."

      def demos
        demo Docs::Examples::Drawer::Default, title: "Default"
        demo Docs::Examples::Drawer::ScrollableContent, title: "Scrollable Content"
        demo Docs::Examples::Drawer::Sides, title: "Sides"
      end
    end
  end
end
