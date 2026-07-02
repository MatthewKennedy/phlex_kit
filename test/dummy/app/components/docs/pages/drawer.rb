# frozen_string_literal: true

module Docs
  module Pages
    class Drawer < Docs::BasePage
      self.description = "A bottom sheet with a grab handle — vaul replaced by the kit's clone machinery."
      def demos
        demo Docs::Examples::Drawer::Default, title: "Move goal"
      end
    end
  end
end
