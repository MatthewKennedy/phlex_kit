# frozen_string_literal: true

module Docs
  module Examples
    module Select
      class Scrollable < Phlex::HTML
        def view_template
          div(style: "width: 100%; max-width: 15rem;") do
            render PhlexKit::Select.new do
              render PhlexKit::SelectInput.new(name: "sel-country")
              render PhlexKit::SelectTrigger.new do
                render PhlexKit::SelectValue.new(placeholder: "Select a country")
              end
              # The viewport caps its height and scrolls.
              render PhlexKit::SelectContent.new do
                render PhlexKit::SelectGroup.new do
                  render PhlexKit::SelectLabel.new { "Countries" }
                  %w[Australia Austria Belgium Brazil Canada Denmark Finland France Germany Ireland Italy Japan Netherlands Norway Portugal Spain Sweden Switzerland].each do |c|
                    render PhlexKit::SelectItem.new(value: c.downcase) { c }
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
