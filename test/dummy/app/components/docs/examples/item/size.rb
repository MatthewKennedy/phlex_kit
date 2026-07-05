# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class Size < Phlex::HTML
        ROWS = [
          [ :md, "Default Size", "The standard size for most use cases." ],
          [ :sm, "Small Size", "A compact size for dense layouts." ],
          [ :xs, "Extra Small Size", "The most compact size available." ]
        ].freeze

        def view_template
          div(class: "stack w-md", style: "gap: 1.5rem") do
            ROWS.each do |size, title, description|
              render PhlexKit::Item.new(variant: :outline, size: size) do
                render PhlexKit::ItemMedia.new(variant: :icon) do
                  render PhlexKit::Icon.new(:mail, size: nil)
                end
                render PhlexKit::ItemContent.new do
                  render PhlexKit::ItemTitle.new { title }
                  render PhlexKit::ItemDescription.new { description }
                end
              end
            end
          end
        end
      end
    end
  end
end
