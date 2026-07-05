# frozen_string_literal: true

module Docs
  module Examples
    module ContextMenu
      class Submenu < Phlex::HTML
        def view_template
          render PhlexKit::ContextMenu.new do
            render PhlexKit::ContextMenuTrigger.new { trigger_box }
            render PhlexKit::ContextMenuContent.new do
              render PhlexKit::ContextMenuItem.new { "Back" }
              render PhlexKit::ContextMenuItem.new { "Forward" }
              render PhlexKit::ContextMenuItem.new { "Reload" }
              render PhlexKit::ContextMenuSub.new do
                render PhlexKit::ContextMenuSubTrigger.new { "More Tools" }
                render PhlexKit::ContextMenuSubContent.new do
                  render PhlexKit::ContextMenuItem.new { "Save Page As…" }
                  render PhlexKit::ContextMenuItem.new { "Create Shortcut…" }
                  render PhlexKit::ContextMenuItem.new { "Name Window…" }
                  render PhlexKit::ContextMenuSeparator.new
                  render PhlexKit::ContextMenuItem.new { "Developer Tools" }
                end
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
