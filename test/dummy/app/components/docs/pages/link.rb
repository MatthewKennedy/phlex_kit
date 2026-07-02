# frozen_string_literal: true

module Docs
  module Pages
    class Link < Docs::BasePage
      self.description = "Anchor styled as an inline link or any button variant."
      def demos
        demo Docs::Examples::Link::Default, title: "Variants"
      end
    end
  end
end
