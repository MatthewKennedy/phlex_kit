# frozen_string_literal: true

module Docs
  module Examples
    module Resizable
      class Horizontal < Phlex::HTML
        def view_template
          div(class: "w-sm", style: "height: 200px; border: 1px solid var(--pk-border); border-radius: var(--pk-radius); overflow: hidden;") do
            render PhlexKit::ResizablePanelGroup.new do
              render PhlexKit::ResizablePanel.new do
                div(class: "docs-panel") { span(style: "font-weight: 600") { "One" } }
              end
              render PhlexKit::ResizableHandle.new(with_handle: true)
              render PhlexKit::ResizablePanel.new do
                render PhlexKit::ResizablePanelGroup.new(direction: :vertical) do
                  render PhlexKit::ResizablePanel.new do
                    div(class: "docs-panel") { span(style: "font-weight: 600") { "Two" } }
                  end
                  render PhlexKit::ResizableHandle.new(with_handle: true)
                  render PhlexKit::ResizablePanel.new(default_size: 3) do
                    div(class: "docs-panel") { span(style: "font-weight: 600") { "Three" } }
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
