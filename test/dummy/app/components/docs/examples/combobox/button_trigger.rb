# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class ButtonTrigger < Phlex::HTML
        FRUITS = %w[Apple Banana Cherry Grape].freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::Combobox.new(term: "fruits") do
              render PhlexKit::ComboboxTrigger.new(placeholder: "Select fruits")
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxSearchInput.new(placeholder: "Search fruits…")
                render PhlexKit::ComboboxList.new do
                  render PhlexKit::ComboboxItem.new do
                    render PhlexKit::ComboboxToggleAllCheckbox.new
                    span { "Select all" }
                  end
                  FRUITS.each do |fruit|
                    render PhlexKit::ComboboxItem.new do
                      render PhlexKit::ComboboxCheckbox.new(name: "fruits[]", value: fruit.downcase)
                      span { fruit }
                      render PhlexKit::ComboboxItemIndicator.new
                    end
                  end
                  render PhlexKit::ComboboxEmptyState.new { "No fruits found" }
                end
              end
            end
          end
        end
      end
    end
  end
end
