# frozen_string_literal: true

module Docs
  module Pages
    class Carousel < Docs::BasePage
      self.description = "A carousel with motion and swipe built with a translate engine — no embla."
      def demos
        demo Docs::Examples::Carousel::Default, title: "Default"
        demo Docs::Examples::Carousel::MultiUp, title: "Sized slides"
      end
    end
  end
end
