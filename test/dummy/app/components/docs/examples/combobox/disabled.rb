# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class Disabled < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Combobox.new do
              render PhlexKit::ComboboxInputTrigger.new(placeholder: "Select a framework", disabled: true)
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxList.new do
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
