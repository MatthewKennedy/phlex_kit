# frozen_string_literal: true

module Docs
  module Examples
    module Resizable
      class Horizontal < Phlex::HTML
        def view_template
          div(class: "w-lg", style: "height:150px;border:1px solid var(--pk-border);border-radius:var(--pk-radius);overflow:hidden") do
            render PhlexKit::ResizablePanelGroup.new do
              render PhlexKit::ResizablePanel.new do
                div(class: "docs-panel") { "One" }
              end
              render PhlexKit::ResizableHandle.new
              render PhlexKit::ResizablePanel.new(default_size: 2) do
                div(class: "docs-panel") { "Two" }
              end
            end
          end
        end
      end
    end
  end
end
