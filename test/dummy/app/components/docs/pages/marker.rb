# frozen_string_literal: true

module Docs
  module Pages
    class Marker < Docs::BasePage
      self.description = "An inline status, system note, or labeled separator in a conversation."

      def demos
        demo Docs::Examples::Marker::Variants, title: "Variants"
        demo Docs::Examples::Marker::Status, title: "Status"
        demo Docs::Examples::Marker::Shimmer, title: "Shimmer"
        demo Docs::Examples::Marker::Separator, title: "Separator"
        demo Docs::Examples::Marker::Border, title: "Border"
        demo Docs::Examples::Marker::WithIcon, title: "With Icon"
        demo Docs::Examples::Marker::LinksAndButtons, title: "Links and Buttons"
      end
    end
  end
end
