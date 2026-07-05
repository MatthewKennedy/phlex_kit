# frozen_string_literal: true

module Docs
  module Pages
    class Carousel < Docs::BasePage
      self.description = "A carousel with motion and swipe built with a translate engine — no embla."

      def demos
        demo Docs::Examples::Carousel::Default, title: "Default"
        demo Docs::Examples::Carousel::Sizes, title: "Sizes"
        demo Docs::Examples::Carousel::Spacing, title: "Spacing"
        demo Docs::Examples::Carousel::Orientation, title: "Orientation"
      end
    end
  end
end
