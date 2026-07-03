# frozen_string_literal: true

module Docs
  module Pages
    class ScrollFade < Docs::BasePage
      self.title = "Scroll Fade"
      self.description = "Masks the edges of a scrollable container while more content exists in that direction."
      def demos
        demo Docs::Examples::ScrollFade::Default, title: "Default"
      end
    end
  end
end
