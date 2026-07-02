# frozen_string_literal: true

module Docs
  module Pages
    class Bubble < Docs::BasePage
      self.description = "Chat bubbles in every variant — compose inside Message rows."
      def demos
        demo Docs::Examples::Bubble::Variants, title: "Variants"
      end
    end
  end
end
