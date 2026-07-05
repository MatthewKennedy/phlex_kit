# frozen_string_literal: true

module Docs
  module Examples
    module Separator
      class List < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: .5rem; font-size: .875rem;") do
            3.times do |i|
              render PhlexKit::Separator.new if i.positive?
              dl(style: "display: flex; align-items: center; justify-content: space-between; margin: 0;") do
                dt { "Item #{i + 1}" }
                dd(style: "margin: 0; color: var(--pk-muted);") { "Value #{i + 1}" }
              end
            end
          end
        end
      end
    end
  end
end
