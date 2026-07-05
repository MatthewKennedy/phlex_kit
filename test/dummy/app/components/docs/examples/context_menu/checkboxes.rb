# frozen_string_literal: true

module Docs
  module Examples
    module ContextMenu
      class Checkboxes < Phlex::HTML
        def view_template
          render PhlexKit::ContextMenu.new do
            render PhlexKit::ContextMenuTrigger.new { trigger_box }
            render PhlexKit::ContextMenuContent.new do
              render PhlexKit::ContextMenuCheckboxItem.new(checked: true) { "Show Bookmarks Bar" }
              render PhlexKit::ContextMenuCheckboxItem.new { "Show Full URLs" }
              render PhlexKit::ContextMenuCheckboxItem.new(checked: true) { "Show Toolbar" }
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
