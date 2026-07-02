# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class BadgeTrigger < Phlex::HTML
        TAGS = %w[ruby rails phlex stimulus css].freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::Combobox.new(term: "tags") do
              render PhlexKit::ComboboxBadgeTrigger.new(placeholder: "Add tags", clear_button: true)
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxList.new do
                  TAGS.each do |tag|
                    render PhlexKit::ComboboxItem.new do
                      render PhlexKit::ComboboxCheckbox.new(name: "tags[]", value: tag)
                      span { tag }
                      render PhlexKit::ComboboxItemIndicator.new
                    end
                  end
                  render PhlexKit::ComboboxEmptyState.new { "No tags found" }
                end
              end
            end
          end
        end
      end
    end
  end
end
