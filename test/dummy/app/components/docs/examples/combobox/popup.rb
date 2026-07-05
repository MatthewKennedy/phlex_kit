# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class Popup < Phlex::HTML
        COUNTRIES = {
          "Europe" => [ [ "france", "France" ], [ "germany", "Germany" ], [ "italy", "Italy" ], [ "united-kingdom", "United Kingdom" ] ],
          "Asia" => [ [ "china", "China" ], [ "japan", "Japan" ], [ "south-korea", "South Korea" ] ],
          "North America" => [ [ "canada", "Canada" ], [ "mexico", "Mexico" ], [ "united-states", "United States" ] ]
        }.freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::Combobox.new do
              render PhlexKit::ComboboxTrigger.new(placeholder: "Select country")
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxSearchInput.new(placeholder: "Search")
                render PhlexKit::ComboboxList.new do
                  COUNTRIES.each do |continent, countries|
                    render PhlexKit::ComboboxListGroup.new(label: continent) do
                      countries.each do |value, label|
                        render PhlexKit::ComboboxItem.new do
                          render PhlexKit::ComboboxRadio.new(name: "cb-country", value: value)
                          span { label }
                          render PhlexKit::ComboboxItemIndicator.new
                        end
                      end
                    end
                  end
                  render PhlexKit::ComboboxEmptyState.new { "No items found." }
                end
              end
            end
          end
        end
      end
    end
  end
end
