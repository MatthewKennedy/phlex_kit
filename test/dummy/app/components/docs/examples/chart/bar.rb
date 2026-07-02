# frozen_string_literal: true

module Docs
  module Examples
    module Chart
      class Bar < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::Chart.new(options: {
              type: "bar",
              data: { labels: %w[Jan Feb Mar Apr May Jun],
                      datasets: [ { label: "Revenue", data: [ 12, 19, 14, 22, 17, 25 ], borderWidth: 0, borderRadius: 4 } ] },
              options: { plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } } } }
            })
          end
        end
      end
    end
  end
end
