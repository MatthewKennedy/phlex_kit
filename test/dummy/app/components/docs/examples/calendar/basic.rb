# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class Basic < Phlex::HTML
        def view_template
          div(style: "border: 1px solid var(--pk-border); border-radius: var(--pk-radius); width: fit-content;") do
            render PhlexKit::Calendar.new(selected_date: "2026-06-12")
          end
        end
      end
    end
  end
end
