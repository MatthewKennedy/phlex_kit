# frozen_string_literal: true

module Docs
  module Examples
    module ScrollArea
      class Default < Phlex::HTML
        def view_template
          div(class: "w-sm", style: "height:200px;border:1px solid var(--pk-border);border-radius:var(--pk-radius)") do
            render PhlexKit::ScrollArea.new(style: "height:100%;padding:1rem") do
              strong(style: "font-size:.875rem") { "Tags" }
              20.times do |i|
                div(style: "padding:.5rem 0;border-bottom:1px solid var(--pk-border);font-size:.875rem") { "v1.2.0-beta.#{20 - i}" }
              end
            end
          end
        end
      end
    end
  end
end
