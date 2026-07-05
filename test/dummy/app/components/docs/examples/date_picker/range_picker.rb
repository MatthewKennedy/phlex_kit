# frozen_string_literal: true

module Docs
  module Examples
    module DatePicker
      class RangePicker < Phlex::HTML
        def view_template
          # mode: :range writes "start – end" into the bound input.
          render PhlexKit::DatePicker.new(
            id: "dp-range",
            name: "stay",
            label: "Your stay",
            placeholder: "Select dates",
            calendar_attrs: { mode: :range, range_start: "2026-06-09", range_end: "2026-06-17" },
            value: "2026-06-09 – 2026-06-17"
          )
        end
      end
    end
  end
end
