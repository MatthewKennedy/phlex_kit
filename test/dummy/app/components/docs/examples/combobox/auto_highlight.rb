# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class AutoHighlight < Phlex::HTML
        FRAMEWORKS = %w[Next.js SvelteKit Nuxt.js Remix Astro].freeze

        def view_template
          div(class: "w-sm") do
            # auto_highlight keeps the first match marked while you type —
            # Enter picks it immediately.
            render PhlexKit::Combobox.new(auto_highlight: true) do
              render PhlexKit::ComboboxInputTrigger.new(placeholder: "Select a framework")
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxList.new do
                  FRAMEWORKS.each do |framework|
                    render PhlexKit::ComboboxItem.new do
                      render PhlexKit::ComboboxRadio.new(name: "cb-highlight", value: framework.downcase)
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
