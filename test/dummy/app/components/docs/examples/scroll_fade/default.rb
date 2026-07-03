# frozen_string_literal: true

module Docs
  module Examples
    module ScrollFade
      class Default < Phlex::HTML
        def view_template
          div(class: "w-sm", style: "height:180px") do
            # The controller toggles data-at-start/data-at-end so the fade only
            # shows where there is more to scroll.
            div(class: "pk-scroll-fade", style: "height:100%", data: { controller: "phlex-kit--scroll-fade" }) do
              14.times do |i|
                div(style: "padding:.5rem .25rem;border-bottom:1px solid var(--pk-border);font-size:.875rem") { "Row #{i + 1}" }
              end
            end
          end
        end
      end
    end
  end
end
