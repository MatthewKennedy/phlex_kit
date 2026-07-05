# frozen_string_literal: true

module Docs
  module Examples
    module ScrollArea
      class Horizontal < Phlex::HTML
        def view_template
          div(class: "w-sm", style: "border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) - 2px);") do
            render PhlexKit::ScrollArea.new do
              div(style: "display: flex; gap: 1rem; padding: 1rem; width: max-content;") do
                8.times do |i|
                  figure(style: "margin: 0; flex: none;") do
                    div(style: "width: 9rem; aspect-ratio: 3/4; border-radius: calc(var(--pk-radius) - 2px); overflow: hidden;") do
                      img(src: "https://avatar.vercel.sh/artwork-#{i + 1}", alt: "Artwork #{i + 1}", style: "width: 100%; height: 100%; object-fit: cover; filter: grayscale(1);")
                    end
                    figcaption(style: "padding-top: .5rem; font-size: .75rem; color: var(--pk-muted);") do
                      plain "Photo "
                      span(style: "font-weight: 600; color: var(--pk-text);") { "##{i + 1}" }
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
