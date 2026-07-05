# frozen_string_literal: true

module Docs
  module Examples
    module DatePicker
      class WithTime < Phlex::HTML
        def view_template
          div(class: "row", style: "align-items: flex-end") do
            render PhlexKit::DatePicker.new(id: "dp-time-date", name: "meeting_date", label: "Date", placeholder: "Select date")
            render PhlexKit::Field.new(style: "width: auto") do
              render PhlexKit::FieldLabel.new(for: "dp-time-time") { "Time" }
              render PhlexKit::Input.new(id: "dp-time-time", type: :time, value: "10:30")
            end
          end
        end
      end
    end
  end
end
