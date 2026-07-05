# frozen_string_literal: true

module Docs
  module Examples
    module Chart
      class AddAxis < Phlex::HTML
        def view_template
          div(class: "w-md") do
            # Step 3 — add an x-axis: their <XAxis dataKey="month" /> is the x
            # scale's ticks. (Their 3-letter tickFormatter would be a
            # ticks.callback — use short labels when options travel as JSON.)
            render PhlexKit::Chart.new(options: {
              type: "bar",
              data: { labels: %w[January February March April May June],
                      datasets: [
                        { label: "Desktop", data: [ 186, 305, 237, 73, 209, 214 ], borderWidth: 0, borderRadius: 4 },
                        { label: "Mobile", data: [ 80, 200, 120, 190, 130, 140 ], borderWidth: 0, borderRadius: 4 }
                      ] },
              options: {
                plugins: { legend: { display: false }, tooltip: { enabled: false } },
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
