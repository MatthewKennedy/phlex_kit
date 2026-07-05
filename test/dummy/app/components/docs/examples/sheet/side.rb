# frozen_string_literal: true

module Docs
  module Examples
    module Sheet
      class Side < Phlex::HTML
        def view_template
          div(class: "row") do
            [ :top, :right, :bottom, :left ].each do |side|
              render PhlexKit::Sheet.new do
                render PhlexKit::SheetTrigger.new do
                  render PhlexKit::Button.new(variant: :outline) { side.to_s.capitalize }
                end
                render PhlexKit::SheetContent.new(side: side) do
                  render PhlexKit::SheetHeader.new do
                    render PhlexKit::SheetTitle.new { "Sheet from the #{side}" }
                    render PhlexKit::SheetDescription.new { "This sheet slides in from the #{side} edge of the screen." }
                  end
                  render PhlexKit::SheetFooter.new do
                    render PhlexKit::SheetClose.new do
                      render PhlexKit::Button.new(variant: :outline) { "Close" }
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
end
