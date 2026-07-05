# frozen_string_literal: true

module Docs
  module Examples
    module ScrollFade
      class FadeSize < Phlex::HTML
        def view_template
          div(class: "stack", style: "width: 100%; max-width: 20rem; gap: 1.5rem;") do
            { "1rem" => "--pk-scroll-fade-size: 1rem", "6rem" => "--pk-scroll-fade-size: 6rem" }.each do |label, style|
              div(class: "stack", style: "gap: .75rem") do
                div(style: "overflow: hidden; border: 1px solid var(--pk-border); border-radius: 1rem;") do
                  div(class: "pk-scroll-fade", style: "height: 12rem; scrollbar-width: none; #{style};", data: { controller: "phlex-kit--scroll-fade" }) do
                    div(class: "stack", style: "gap: .375rem; padding: .375rem;") do
                      8.times do |i|
                        div(style: "border-radius: var(--pk-radius); background: var(--pk-surface-2); padding: .625rem .75rem; font-size: .875rem;") { "Item #{i + 1}" }
                      end
                    end
                  end
                end
                p(style: "margin: 0; text-align: center; font-family: var(--pk-font-mono); font-size: .75rem; color: var(--pk-muted);") { "--pk-scroll-fade-size: #{label}" }
              end
            end
          end
        end
      end
    end
  end
end
