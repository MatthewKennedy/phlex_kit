# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class MinDate < Phlex::HTML
        def view_template
          div(style: "border: 1px solid var(--pk-border); border-radius: var(--pk-radius)") do
            render PhlexKit::Calendar.new(min_date: Date.today)
          end
        end
      end
    end
  end
end
