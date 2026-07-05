# frozen_string_literal: true

module Docs
  module Pages
    class Chart < Docs::BasePage
      self.description = "Beautiful charts. The host supplies the library (window.Chart); series take --pk-chart-1..5. The steps below mirror shadcn's build-a-chart tutorial — see docs/06-CHARTS.md."

      def demos
        demo Docs::Examples::Chart::FirstChart, title: "Your First Chart"
        demo Docs::Examples::Chart::AddGrid, title: "Add a Grid"
        demo Docs::Examples::Chart::AddAxis, title: "Add an Axis"
        demo Docs::Examples::Chart::AddTooltip, title: "Add Tooltip"
        demo Docs::Examples::Chart::AddLegend, title: "Add Legend"
        demo Docs::Examples::Chart::Area, title: "Area"
        demo Docs::Examples::Chart::Bar, title: "Bar"
        demo Docs::Examples::Chart::Doughnut, title: "Doughnut"
      end
    end
  end
end
