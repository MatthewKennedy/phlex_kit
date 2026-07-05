# frozen_string_literal: true

module Docs
  module Examples
    module ScrollFade
      class Horizontal < Phlex::HTML
        def view_template
          div(style: "width: 100%; max-width: 20rem; overflow: hidden; border: 1px solid var(--pk-border); border-radius: 1rem;") do
            div(class: "pk-scroll-fade horizontal", style: "scrollbar-width: none;", data: { controller: "phlex-kit--scroll-fade", phlex_kit__scroll_fade_axis_value: "x" }) do
              div(class: "row", style: "gap: .375rem; padding: .375rem; width: max-content;") do
                12.times do |i|
                  div(style: "border-radius: var(--pk-radius); background: var(--pk-surface-2); padding: .625rem .75rem; font-size: .875rem; flex: none;") { "Item #{i + 1}" }
                end
              end
            end
          end
        end
      end
    end
  end
end
