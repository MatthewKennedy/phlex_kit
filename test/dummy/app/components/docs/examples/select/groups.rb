# frozen_string_literal: true

module Docs
  module Examples
    module Select
      class Groups < Phlex::HTML
        GROUPS = {
          "North America" => [ %w[est EST], %w[pst PST] ],
          "Europe & Africa" => [ %w[gmt GMT], %w[cet CET] ],
          "Asia" => [ %w[ist IST], %w[jst JST] ]
        }.freeze

        def view_template
          div(style: "width: 100%; max-width: 15rem;") do
            render PhlexKit::Select.new do
              render PhlexKit::SelectInput.new(name: "sel-tz")
              render PhlexKit::SelectTrigger.new do
                render PhlexKit::SelectValue.new(placeholder: "Select a timezone")
              end
              render PhlexKit::SelectContent.new do
                GROUPS.each_with_index do |(label, zones), index|
                  render PhlexKit::SelectSeparator.new if index.positive?
                  render PhlexKit::SelectGroup.new do
                    render PhlexKit::SelectLabel.new { label }
                    zones.each do |value, text|
                      render PhlexKit::SelectItem.new(value: value) { "#{text} — #{label}" }
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
end
