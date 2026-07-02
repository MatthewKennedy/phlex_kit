# frozen_string_literal: true

module Docs
  module Pages
    class Chart < Docs::BasePage
      self.description = "Beautiful charts. The host supplies the library (window.Chart); series take --pk-chart-1..5."
      def demos
        demo Docs::Examples::Chart::Area, title: "Area"
        demo Docs::Examples::Chart::Bar, title: "Bar"
        demo Docs::Examples::Chart::Doughnut, title: "Doughnut"
      end
    end
  end
end
