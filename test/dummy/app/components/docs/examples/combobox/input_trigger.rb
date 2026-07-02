# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class InputTrigger < Phlex::HTML
        CITIES = %w[Amsterdam Berlin Copenhagen Dublin].freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::Combobox.new do
              render PhlexKit::ComboboxInputTrigger.new(placeholder: "Pick a city")
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxList.new do
                  CITIES.each do |city|
                    render PhlexKit::ComboboxItem.new do
                      render PhlexKit::ComboboxRadio.new(name: "city", value: city.downcase)
                      span { city }
                      render PhlexKit::ComboboxItemIndicator.new
                    end
                  end
                  render PhlexKit::ComboboxEmptyState.new { "No cities found" }
                end
              end
            end
          end
        end
      end
    end
  end
end
