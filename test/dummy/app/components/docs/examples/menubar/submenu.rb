# frozen_string_literal: true

module Docs
  module Examples
    module Menubar
      class Submenu < Phlex::HTML
        def view_template
          render PhlexKit::Menubar.new do
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "File" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarItem.new { "New Tab" }
                render PhlexKit::MenubarSub.new do
                  render PhlexKit::MenubarSubTrigger.new { "Share" }
                  render PhlexKit::MenubarSubContent.new do
                    render PhlexKit::MenubarItem.new { "Email link" }
                    render PhlexKit::MenubarItem.new { "Messages" }
                    render PhlexKit::MenubarItem.new { "Notes" }
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
