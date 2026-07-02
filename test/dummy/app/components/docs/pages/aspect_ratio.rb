# frozen_string_literal: true

module Docs
  module Pages
    class AspectRatio < Docs::BasePage
      self.description = "Displays content within a desired ratio."
      def demos
        demo Docs::Examples::AspectRatio::Default, title: "16 / 9"
      end
    end
  end
end
