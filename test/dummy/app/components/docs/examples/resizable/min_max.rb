# frozen_string_literal: true

module Docs
  module Examples
    module Resizable
      class MinMax < Phlex::HTML
        def view_template
          div(class: "w-sm", style: "height: 120px; border: 1px solid var(--pk-border); border-radius: var(--pk-radius); overflow: hidden;") do
            render PhlexKit::ResizablePanelGroup.new do
              render PhlexKit::ResizablePanel.new(default_size: 30, min_size: 20, max_size: 60) do
                div(class: "docs-panel") { span(style: "font-weight: 600") { "20–60%" } }
              end
              render PhlexKit::ResizableHandle.new(with_handle: true)
              render PhlexKit::ResizablePanel.new(default_size: 70) do
                div(class: "docs-panel") { span(style: "font-weight: 600") { "Two" } }
              end
            end
          end
        end
      end
    end
  end
end
