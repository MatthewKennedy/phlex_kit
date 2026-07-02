# frozen_string_literal: true

module Docs
  module Examples
    module Drawer
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Drawer.new do
            render PhlexKit::DrawerTrigger.new do
              render PhlexKit::Button.new(variant: :outline) { "Open drawer" }
            end
            render PhlexKit::DrawerContent.new do
              render PhlexKit::DrawerHeader.new do
                render PhlexKit::DrawerTitle.new { "Move goal" }
                render PhlexKit::DrawerDescription.new { "Set your daily activity goal." }
              end
              render PhlexKit::DrawerFooter.new do
                render PhlexKit::DrawerClose.new do
                  render PhlexKit::Button.new { "Submit" }
                end
                render PhlexKit::DrawerClose.new do
                  render PhlexKit::Button.new(variant: :outline) { "Cancel" }
                end
              end
            end
          end
        end
      end
    end
  end
end
