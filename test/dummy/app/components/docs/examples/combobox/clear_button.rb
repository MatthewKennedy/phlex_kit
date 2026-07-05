# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class ClearButton < Phlex::HTML
        FRAMEWORKS = %w[Next.js SvelteKit Nuxt.js Remix Astro].freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::Combobox.new(term: "frameworks") do
              render PhlexKit::ComboboxBadgeTrigger.new(placeholder: "Select frameworks", clear_button: true)
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxList.new do
                  FRAMEWORKS.each do |framework|
                    render PhlexKit::ComboboxItem.new do
                      render PhlexKit::ComboboxCheckbox.new(name: "cb-clear[]", value: framework.downcase, checked: framework == "Next.js")
                      span { framework }
                      render PhlexKit::ComboboxItemIndicator.new
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
