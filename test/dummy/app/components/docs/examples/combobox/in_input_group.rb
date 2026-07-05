# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class InInputGroup < Phlex::HTML
        FRAMEWORKS = %w[Next.js SvelteKit Nuxt.js Remix Astro].freeze

        def view_template
          div(class: "w-sm") do
            # The InputGroup shell carries the chrome; the trigger flattens.
            render PhlexKit::InputGroup.new do
              render PhlexKit::InputGroupAddon.new do
                render PhlexKit::Icon.new(:search, size: nil)
              end
              render PhlexKit::Combobox.new(style: "flex: 1") do
                render PhlexKit::ComboboxInputTrigger.new(placeholder: "Search frameworks...", style: "border: 0; background: transparent; box-shadow: none;")
                render PhlexKit::ComboboxPopover.new do
                  render PhlexKit::ComboboxList.new do
                    FRAMEWORKS.each do |framework|
                      render PhlexKit::ComboboxItem.new do
                        render PhlexKit::ComboboxRadio.new(name: "cb-ig", value: framework.downcase)
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
end
