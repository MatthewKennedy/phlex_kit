# frozen_string_literal: true

module Docs
  module Examples
    module MessageScroller
      class Anchoring < Phlex::HTML
        def view_template
          div(class: "stack w-lg", style: "gap: .75rem") do
            div(style: "height: 240px") do
              render PhlexKit::MessageScroller.new(id: "ms-anchoring") do
                div(style: "height: 100%; overflow-y: auto;", data: { phlex_kit__message_scroller_target: "viewport" }) do
                  div(class: "stack", style: "padding: .25rem", data: { phlex_kit__message_scroller_target: "content" }) do
                    render PhlexKit::Message.new do
                      render PhlexKit::MessageContent.new do
                        render PhlexKit::Bubble.new(variant: :muted) do
                          render PhlexKit::BubbleContent.new { "Ask me anything — each new question anchors near the top with a peek of the previous turn." }
                        end
                      end
                    end
                  end
                end
              end
            end
            render PhlexKit::Button.new(variant: :outline, size: :sm, onclick: safe("window.pkDemoTurn('ms-anchoring')")) { "Send a new turn" }
            # A [data-scroll-anchor] row settles near the viewport top,
            # keeping previousItemPeek pixels of the prior turn visible.
            script { safe(<<~JS) }
              window.pkDemoTurn ||= function(id) {
                const scroller = document.getElementById(id)
                const content = scroller.querySelector('[data-phlex-kit--message-scroller-target="content"]')
                const n = content.querySelectorAll("[data-scroll-anchor]").length + 1
                const turn = document.createElement("div")
                turn.className = "pk-message"
                turn.dataset.slot = "message"
                turn.dataset.align = "end"
                turn.setAttribute("data-scroll-anchor", "")
                turn.innerHTML = '<div class="pk-message-content"><div class="pk-bubble" data-variant="default" data-align="end" data-slot="bubble"><div class="pk-bubble-content" data-slot="bubble-content">Question ' + n + '</div></div></div>'
                content.appendChild(turn)
                const reply = document.createElement("div")
                reply.className = "pk-message"
                reply.dataset.slot = "message"
                reply.innerHTML = '<div class="pk-message-content"><div class="pk-bubble" data-variant="muted" data-align="start" data-slot="bubble"><div class="pk-bubble-content" data-slot="bubble-content">Answer ' + n + ' — long enough to show the anchored turn holding near the top while the reply grows below it.</div></div></div>'
                setTimeout(() => content.appendChild(reply), 500)
              }
            JS
          end
        end
      end
    end
  end
end
