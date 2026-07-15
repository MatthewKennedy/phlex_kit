# frozen_string_literal: true

module Docs
  module Examples
    module HoverCard
      class Basic < Phlex::HTML
        def view_template
          render PhlexKit::HoverCard.new do
            render PhlexKit::HoverCardTrigger.new do
              render PhlexKit::Button.new(variant: :link) { "Hover Here" }
            end
            render PhlexKit::HoverCardContent.new do
              div(style: "font-weight: 600") { "@nextjs" }
              div { "The React Framework – created and maintained by @vercel." }
              div(style: "margin-top: .25rem; font-size: .75rem; color: var(--pk-muted);") { "Joined December 2021" }
            end
          end
        end
      end
    end
  end
end
