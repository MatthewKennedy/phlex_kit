# frozen_string_literal: true

module Docs
  module Examples
    module ScrollFade
      class Default < Phlex::HTML
        def view_template
          div(style: "width: 100%; max-width: 20rem; overflow: hidden; border: 1px solid var(--pk-border); border-radius: 1rem;") do
            # The controller toggles data-at-start/data-at-end so the fade
            # only shows where there is more to scroll.
            div(class: "pk-scroll-fade", style: "height: 18rem; scrollbar-width: none;", data: { controller: "phlex-kit--scroll-fade" }) do
              div(class: "stack", style: "gap: .375rem; padding: .375rem;") do
                12.times do |i|
                  div(style: "border-radius: var(--pk-radius); background: var(--pk-surface-2); padding: .625rem .75rem; font-size: .875rem;") { "Item #{i + 1}" }
                end
              end
            end
          end
        end
      end
    end
  end
end
