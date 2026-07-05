# frozen_string_literal: true

module Docs
  module Examples
    module Calendar
      class Multiple < Phlex::HTML
        def view_template
          # mode: :multiple toggles days on and off.
          render PhlexKit::Card.new(style: "width: fit-content; padding: 0;") do
            render PhlexKit::Calendar.new(mode: :multiple, selected_dates: %w[2026-06-04 2026-06-09 2026-06-17])
          end
        end
      end
    end
  end
end
