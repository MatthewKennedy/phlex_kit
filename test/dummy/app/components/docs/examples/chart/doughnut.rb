# frozen_string_literal: true

module Docs
  module Examples
    module Chart
      class Doughnut < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Chart.new(options: {
              type: "doughnut",
              data: { labels: %w[Chrome Safari Firefox Edge Other], datasets: [ { data: [ 275, 200, 187, 173, 90 ] } ] },
              options: { cutout: "60%" }
            })
          end
        end
      end
    end
  end
end
