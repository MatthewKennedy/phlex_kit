# frozen_string_literal: true

module Docs
  module Examples
    module Chart
      class FirstChart < Phlex::HTML
        def view_template
          div(class: "w-md") do
            # Step 1 — the bare chart: two series on --pk-chart-1/-2, with
            # grid, axes, tooltip and legend all off. Each next step turns
            # one Chart.js option back on.
            render PhlexKit::Chart.new(options: {
              type: "bar",
              data: { labels: %w[January February March April May June],
                      datasets: [
                        { label: "Desktop", data: [ 186, 305, 237, 73, 209, 214 ], borderWidth: 0, borderRadius: 4 },
                        { label: "Mobile", data: [ 80, 200, 120, 190, 130, 140 ], borderWidth: 0, borderRadius: 4 }
                      ] },
              options: {
                plugins: { legend: { display: false }, tooltip: { enabled: false } },
                scales: { x: { display: false }, y: { display: false } }
              }
            })
          end
        end
      end
    end
  end
end
