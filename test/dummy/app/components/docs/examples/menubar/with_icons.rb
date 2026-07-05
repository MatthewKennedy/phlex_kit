# frozen_string_literal: true

module Docs
  module Examples
    module Menubar
      class WithIcons < Phlex::HTML
        def view_template
          render PhlexKit::Menubar.new do
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "Actions" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarItem.new do
                  render PhlexKit::Icon.new(:pencil, size: nil)
                  plain "Edit"
                end
                render PhlexKit::MenubarItem.new do
                  render PhlexKit::Icon.new(:copy, size: nil)
                  plain "Duplicate"
                end
                render PhlexKit::MenubarSeparator.new
                render PhlexKit::MenubarItem.new(variant: :destructive) do
                  render PhlexKit::Icon.new(:trash, size: nil)
                  plain "Delete"
                end
              end
            end
          end
        end
      end
    end
  end
end
