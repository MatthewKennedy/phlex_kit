# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class Basic < Phlex::HTML
        FRAMEWORKS = %w[Next.js SvelteKit Nuxt.js Remix Astro].freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::Combobox.new do
              render PhlexKit::ComboboxInputTrigger.new(placeholder: "Select a framework")
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxList.new do
                  FRAMEWORKS.each do |framework|
                    render PhlexKit::ComboboxItem.new do
                      render PhlexKit::ComboboxRadio.new(name: "cb-framework", value: framework.downcase)
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
