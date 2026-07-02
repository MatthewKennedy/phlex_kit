# frozen_string_literal: true

module Docs
  module Pages
    class Marker < Docs::BasePage
      self.description = "An inline status, system note, or labeled separator in a conversation."
      def demos
        demo Docs::Examples::Marker::Default, title: "Variants"
      end
    end
  end
end
