# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class WithImage < Phlex::HTML
        SONGS = [
          [ "Midnight City Lights", "Electric Nights", "Neon Dreams", "3:45" ],
          [ "Coffee Shop Conversations", "Urban Stories", "The Morning Brew", "4:05" ],
          [ "Digital Rain", "Binary Beats", "Cyber Symphony", "3:30" ]
        ].freeze

        def view_template
          div(class: "w-md") do
            render PhlexKit::ItemGroup.new do
              SONGS.each do |title, album, artist, duration|
                render PhlexKit::Item.new(variant: :outline, href: "#", role: "listitem") do
                  render PhlexKit::ItemMedia.new(variant: :image) do
                    img(src: "https://avatar.vercel.sh/#{title.downcase.tr(' ', '-')}", alt: title, width: 32, height: 32, style: "filter: grayscale(1)")
                  end
                  render PhlexKit::ItemContent.new do
                    render PhlexKit::ItemTitle.new do
                      plain "#{title} – "
                      span(style: "color: var(--pk-muted)") { album }
                    end
                    render PhlexKit::ItemDescription.new { artist }
                  end
                  render PhlexKit::ItemContent.new(style: "flex: none; text-align: center;") do
                    render PhlexKit::ItemDescription.new { duration }
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
