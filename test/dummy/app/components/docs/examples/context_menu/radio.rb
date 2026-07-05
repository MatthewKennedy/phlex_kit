# frozen_string_literal: true

module Docs
  module Examples
    module ContextMenu
      class Radio < Phlex::HTML
        def view_template
          render PhlexKit::ContextMenu.new do
            render PhlexKit::ContextMenuTrigger.new { trigger_box }
            render PhlexKit::ContextMenuContent.new do
              render PhlexKit::ContextMenuLabel.new { "People" }
              render PhlexKit::ContextMenuSeparator.new
              render PhlexKit::ContextMenuRadioGroup.new do
                render PhlexKit::ContextMenuRadioItem.new(name: "cm-person", value: "pedro", checked: true) { "Pedro Duarte" }
                render PhlexKit::ContextMenuRadioItem.new(name: "cm-person", value: "colm") { "Colm Tuite" }
              end
            end
          end
        end

        private

        def trigger_box
          div(style: "display:flex;aspect-ratio:16/9;width:100%;max-width:20rem;align-items:center;justify-content:center;border:1px dashed var(--pk-border);border-radius:.75rem;font-size:.875rem") do
            "Right click here"
          end
        end
      end
    end
  end
end
