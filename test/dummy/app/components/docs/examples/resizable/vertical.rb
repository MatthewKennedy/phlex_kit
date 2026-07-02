# frozen_string_literal: true

module Docs
  module Examples
    module Resizable
      class Vertical < Phlex::HTML
        def view_template
          div(class: "w-md", style: "height:200px;border:1px solid var(--pk-border);border-radius:var(--pk-radius);overflow:hidden") do
            render PhlexKit::ResizablePanelGroup.new(direction: :vertical) do
              render PhlexKit::ResizablePanel.new do
                div(class: "docs-panel") { "Header" }
              end
              render PhlexKit::ResizableHandle.new
              render PhlexKit::ResizablePanel.new(default_size: 3) do
                div(class: "docs-panel") { "Content" }
              end
            end
          end
        end
      end
    end
  end
end
