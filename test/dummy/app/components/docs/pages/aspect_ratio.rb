# frozen_string_literal: true

module Docs
  module Pages
    class AspectRatio < Docs::BasePage
      self.description = "Displays content within a desired ratio."
      def demos
        demo Docs::Examples::AspectRatio::Default, title: "16 / 9"
        demo Docs::Examples::AspectRatio::Square, title: "Square"
        demo Docs::Examples::AspectRatio::Portrait, title: "Portrait"
      end
    end
  end
end
