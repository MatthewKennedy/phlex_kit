# frozen_string_literal: true

module Docs
  module Examples
    module Menubar
      class Checkbox < Phlex::HTML
        def view_template
          render PhlexKit::Menubar.new do
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "View" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarCheckboxItem.new { "Always Show Bookmarks Bar" }
                render PhlexKit::MenubarCheckboxItem.new(checked: true) { "Always Show Full URLs" }
              end
            end
          end
        end
      end
    end
  end
end
