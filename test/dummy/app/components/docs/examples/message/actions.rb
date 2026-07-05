# frozen_string_literal: true

module Docs
  module Examples
    module Message
      class Actions < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 2rem; padding: 2rem 0;") do
            render PhlexKit::Message.new do
              render PhlexKit::MessageContent.new do
                render PhlexKit::Bubble.new(variant: :muted) do
                  render PhlexKit::BubbleContent.new { "The install failure is coming from the workspace package." }
                end
                render PhlexKit::MessageFooter.new do
                  render PhlexKit::Button.new(variant: :ghost, icon: true, aria: { label: "Copy" }, title: "Copy") do
                    render PhlexKit::Icon.new(:copy, size: nil)
                  end
                  render PhlexKit::Button.new(variant: :ghost, icon: true, aria: { label: "Like" }, title: "Like") do
                    render PhlexKit::Icon.new(:heart, size: nil)
                  end
                end
              end
            end
            render PhlexKit::Message.new(align: :end) do
              render PhlexKit::MessageContent.new do
                render PhlexKit::Bubble.new do
                  render PhlexKit::BubbleContent.new { "Okay drop me a link. Taking a look..." }
                end
                render PhlexKit::MessageFooter.new(style: "gap: .5rem") do
                  span(style: "font-weight: 400; color: var(--pk-red);") { "Failed to send" }
                  render PhlexKit::Button.new(variant: :ghost, size: :xs, icon: true, title: "Retry", aria: { label: "Retry" }) do
                    render PhlexKit::Icon.new(:refresh, size: nil)
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
