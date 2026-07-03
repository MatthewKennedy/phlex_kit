# frozen_string_literal: true

module Docs
  module Examples
    module Card
      class WithImage < Phlex::HTML
        # An <img> before the header runs edge to edge.
        def view_template
          render PhlexKit::Card.new(class: "w-md") do
            img(src: "https://images.unsplash.com/photo-1531554694128-c4c6665f59c2?w=800&dpr=2&q=80", alt: "", style: "height: 160px")
            render PhlexKit::CardHeader.new do
              render PhlexKit::CardTitle.new { "Design systems meetup" }
              render PhlexKit::CardDescription.new { "A practical talk on component APIs, accessibility, and shipping faster." }
              render PhlexKit::CardAction.new do
                render PhlexKit::Badge.new(variant: :secondary) { "Featured" }
              end
            end
            render PhlexKit::CardFooter.new do
              render PhlexKit::Button.new(variant: :outline, size: :sm, style: "width:100%") { "View Event" }
            end
          end
        end
      end
    end
  end
end
