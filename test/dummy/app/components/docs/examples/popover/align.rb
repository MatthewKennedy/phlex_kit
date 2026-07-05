# frozen_string_literal: true

module Docs
  module Examples
    module Popover
      class Align < Phlex::HTML
        def view_template
          div(class: "row") do
            [ :start, :end ].each do |align|
              render PhlexKit::Popover.new do
                render PhlexKit::PopoverTrigger.new do
                  render PhlexKit::Button.new(variant: :outline) { "Align #{align}" }
                end
                render PhlexKit::PopoverContent.new(align: align) do
                  render PhlexKit::PopoverHeader.new do
                    render PhlexKit::PopoverTitle.new { "Aligned #{align}" }
                    render PhlexKit::PopoverDescription.new { "This popover aligns to the trigger's #{align} edge." }
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
