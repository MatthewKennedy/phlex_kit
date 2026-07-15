# frozen_string_literal: true

module Docs
  module Examples
    module ScrollArea
      class Default < Phlex::HTML
        def view_template
          div(style: "height: 18rem; width: 12rem; border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) - 2px);") do
            render PhlexKit::ScrollArea.new(style: "height: 100%", aria: { label: "Tags" }) do
              div(style: "padding: 1rem") do
                h4(style: "margin: 0 0 1rem; font-size: .875rem; font-weight: 500; line-height: 1;") { "Tags" }
                50.downto(1) do |i|
                  div(style: "font-size: .875rem") { "v1.2.0-beta.#{i}" }
                  render PhlexKit::Separator.new(style: "margin: .5rem 0")
                end
              end
            end
          end
        end
      end
    end
  end
end
