# frozen_string_literal: true

module Docs
  module Examples
    module Chart
      class AddLegend < Phlex::HTML
        def view_template
          div(class: "w-md") do
            # Step 5 — add a legend: their <ChartLegend /> is the legend
            # plugin, bottom-positioned like theirs. The series labels come
            # from the datasets — their ChartConfig equivalent.
            render PhlexKit::Chart.new(options: {
              type: "bar",
              data: { labels: %w[January February March April May June],
                      datasets: [
                        { label: "Desktop", data: [ 186, 305, 237, 73, 209, 214 ], borderWidth: 0, borderRadius: 4 },
                        { label: "Mobile", data: [ 80, 200, 120, 190, 130, 140 ], borderWidth: 0, borderRadius: 4 }
                      ] },
              options: {
                plugins: {
                  legend: { display: true, position: "bottom", labels: { boxWidth: 8, boxHeight: 8, usePointStyle: true, pointStyle: "rectRounded" } },
                  tooltip: { enabled: true }
                },
                scales: {
                  x: { display: true, grid: { display: false }, border: { display: false } },
                  y: { display: true, ticks: { display: false }, border: { display: false } }
                }
              }
            })
          end
        end
      end
    end
  end
end
