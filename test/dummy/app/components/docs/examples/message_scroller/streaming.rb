# frozen_string_literal: true

module Docs
  module Examples
    module MessageScroller
      class Streaming < Phlex::HTML
        WORDS = "The build failed during dependency installation because the lockfile drifted from the manifest — regenerate it and rerun the install before retrying the deploy.".split

        def view_template
          div(class: "stack w-lg", style: "gap: .75rem") do
            div(style: "height: 240px") do
              render PhlexKit::MessageScroller.new(id: "ms-streaming") do
                div(style: "height: 100%; overflow-y: auto;", data: { phlex_kit__message_scroller_target: "viewport" }) do
                  div(class: "stack", style: "padding: .25rem", data: { phlex_kit__message_scroller_target: "content" }) do
                    render PhlexKit::Message.new(align: :end) do
                      render PhlexKit::MessageContent.new do
                        render PhlexKit::Bubble.new(align: :end) do
                          render PhlexKit::BubbleContent.new { "Why did the deploy fail?" }
                        end
                      end
                    end
                  end
                end
                # Appears when the reader scrolls away from the live edge.
                button(type: "button", class: "pk-button outline sm pk-message-scroller-jump", data: { phlex_kit__message_scroller_target: "button", action: "phlex-kit--message-scroller#jump" }) { "↓ Latest" }
              end
            end
            render PhlexKit::Button.new(variant: :outline, size: :sm, onclick: safe("window.pkDemoStream('ms-streaming', #{JSON.generate(WORDS)})")) { "Simulate streaming reply" }
            # Word-by-word append into the last ghost bubble — the scroller
            # stays pinned while you're at the live edge, and releases the
            # moment you scroll up (the ↓ button brings you back).
            script { safe(<<~JS) }
              window.pkDemoStream ||= function(id, words) {
                const scroller = document.getElementById(id)
                const content = scroller.querySelector('[data-phlex-kit--message-scroller-target="content"]')
                const row = document.createElement("div")
                row.className = "pk-message"
                row.dataset.slot = "message"
                row.innerHTML = '<div class="pk-message-content"><div class="pk-bubble" data-variant="ghost" data-align="start" data-slot="bubble"><div class="pk-bubble-content" data-slot="bubble-content"></div></div></div>'
                content.appendChild(row)
                const target = row.querySelector(".pk-bubble-content")
                let i = 0
                const timer = setInterval(() => {
                  target.textContent += (i ? " " : "") + words[i]
                  if (++i >= words.length) clearInterval(timer)
                }, 120)
              }
            JS
          end
        end
      end
    end
  end
end
