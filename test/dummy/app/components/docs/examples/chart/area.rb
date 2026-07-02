# frozen_string_literal: true

module Docs
  module Examples
    module Chart
      class Area < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::Chart.new(options: {
              type: "line",
              data: { labels: %w[Jan Feb Mar Apr May Jun], datasets: [
                { label: "Desktop", data: [ 186, 305, 237, 173, 209, 214 ], fill: true },
                { label: "Mobile", data: [ 80, 200, 120, 190, 130, 140 ], fill: true }
              ] },
              options: { plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } } } }
            })
          end
        end
      end
    end
  end
end
