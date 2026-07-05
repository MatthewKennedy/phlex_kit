# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class Groups < Phlex::HTML
        GROUPS = {
          "Frontend" => %w[React Vue Svelte],
          "Backend" => %w[Rails Django Laravel],
          "Mobile" => %w[SwiftUI Flutter]
        }.freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::Combobox.new do
              render PhlexKit::ComboboxInputTrigger.new(placeholder: "Select a framework")
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxList.new do
                  GROUPS.each do |label, frameworks|
                    render PhlexKit::ComboboxListGroup.new(label: label) do
                      frameworks.each do |framework|
                        render PhlexKit::ComboboxItem.new do
                          render PhlexKit::ComboboxRadio.new(name: "cb-grouped", value: framework.downcase)
                          span { framework }
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
