# frozen_string_literal: true

module Docs
  module Pages
    class Shimmer < Docs::BasePage
      self.description = "A highlight sweep across text for loading states. Pure CSS on currentColor — adapts to any text color and dark mode."
      def demos
        demo Docs::Examples::Shimmer::Default, title: "Default"
        demo Docs::Examples::Shimmer::WithMarker, title: "With Marker"
        demo Docs::Examples::Shimmer::Color, title: "Color"
        demo Docs::Examples::Shimmer::DurationSpreadAngle, title: "Duration, spread, angle"
        demo Docs::Examples::Shimmer::OnceAndReverse, title: "Play once & reverse"
      end
    end
  end
end
