# frozen_string_literal: true

module Docs
  module Examples
    module HoverCard
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::HoverCard.new do
            render PhlexKit::HoverCardTrigger.new do
              render PhlexKit::Button.new(variant: :link) { "@nextjs" }
            end
            render PhlexKit::HoverCardContent.new do
              div(class: "stack", style: "gap:.25rem") do
                strong { "@nextjs" }
                span(style: "font-size:.875rem") { "The React Framework — created and maintained by @vercel." }
                span(style: "font-size:.75rem;color:var(--pk-muted)") { "Joined December 2021" }
              end
            end
          end
        end
      end
    end
  end
end
