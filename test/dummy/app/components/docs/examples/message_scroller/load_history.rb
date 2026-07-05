# frozen_string_literal: true

module Docs
  module Examples
    module MessageScroller
      class LoadHistory < Phlex::HTML
        def view_template
          div(class: "stack w-lg", style: "gap: .75rem") do
            render PhlexKit::Button.new(variant: :outline, size: :sm, onclick: safe("window.pkDemoHistory('ms-history')")) { "Load older messages" }
            div(style: "height: 240px") do
              render PhlexKit::MessageScroller.new(id: "ms-history") do
                div(style: "height: 100%; overflow-y: auto;", data: { phlex_kit__message_scroller_target: "viewport" }) do
                  div(class: "stack", style: "padding: .25rem", data: { phlex_kit__message_scroller_target: "content" }) do
                    8.times do |i|
                      render PhlexKit::Message.new(align: i.even? ? :start : :end) do
                        render PhlexKit::MessageContent.new do
                          render PhlexKit::Bubble.new(align: i.even? ? :start : :end, variant: i.even? ? :muted : :default) do
                            render PhlexKit::BubbleContent.new { "Message #{i + 1}" }
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            # Prepended rows don't shove the transcript: preserveOnPrepend
            # keeps the row you're reading exactly where it was.
            script { safe(<<~JS) }
              window.pkDemoHistory ||= function(id) {
                const scroller = document.getElementById(id)
                const content = scroller.querySelector('[data-phlex-kit--message-scroller-target="content"]')
                const batch = document.createDocumentFragment()
                for (let i = 0; i < 3; i++) {
                  const row = document.createElement("div")
                  row.className = "pk-message"
                  row.dataset.slot = "message"
                  row.innerHTML = '<div class="pk-message-content"><div class="pk-bubble" data-variant="outline" data-align="start" data-slot="bubble"><div class="pk-bubble-content" data-slot="bubble-content">Older message</div></div></div>'
                  batch.prepend(row)
                }
                content.prepend(batch)
              }
            JS
          end
        end
      end
    end
  end
end
