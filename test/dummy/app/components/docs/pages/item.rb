# frozen_string_literal: true

module Docs
  module Pages
    class Item < Docs::BasePage
      self.description = "A flexible list row: media, content, and actions."
      def demos
        demo Docs::Examples::Item::Default, title: "Variants"
      end
    end
  end
end
