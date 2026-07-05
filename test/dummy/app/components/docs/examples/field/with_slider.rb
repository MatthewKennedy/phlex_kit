# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class WithSlider < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(class: "w-sm") do
            render PhlexKit::FieldTitle.new { "Price Range" }
            render PhlexKit::FieldDescription.new do
              plain "Set your budget (up to "
              span(style: "font-weight: 500; font-variant-numeric: tabular-nums;") { "$1000" }
              plain ")."
            end
            render PhlexKit::Slider.new(name: "fld-budget", value: 400, min: 0, max: 1000, step: 10, style: "margin-top: .5rem", aria: { label: "Price Range" })
          end
        end
      end
    end
  end
end
