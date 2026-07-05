# frozen_string_literal: true

module Docs
  module Examples
    module Menubar
      class Radio < Phlex::HTML
        def view_template
          render PhlexKit::Menubar.new do
            render PhlexKit::MenubarMenu.new do
              render PhlexKit::MenubarTrigger.new { "Profiles" }
              render PhlexKit::MenubarContent.new do
                render PhlexKit::MenubarRadioGroup.new do
                  render PhlexKit::MenubarRadioItem.new(name: "mb-radio-profile", value: "andy") { "Andy" }
                  render PhlexKit::MenubarRadioItem.new(name: "mb-radio-profile", value: "benoit", checked: true) { "Benoit" }
                  render PhlexKit::MenubarRadioItem.new(name: "mb-radio-profile", value: "luis") { "Luis" }
                end
              end
            end
          end
        end
      end
    end
  end
end
