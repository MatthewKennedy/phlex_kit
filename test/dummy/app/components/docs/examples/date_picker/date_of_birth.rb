# frozen_string_literal: true

module Docs
  module Examples
    module DatePicker
      class DateOfBirth < Phlex::HTML
        def view_template
          # calendar_attrs pass straight through — dropdown caption + max date.
          render PhlexKit::DatePicker.new(
            id: "dp-dob",
            name: "dob",
            label: "Date of birth",
            placeholder: "Select date",
            calendar_attrs: { caption_layout: :dropdown, from_year: 1940, to_year: 2026, max_date: "2026-12-31" }
          )
        end
      end
    end
  end
end
