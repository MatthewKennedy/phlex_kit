# frozen_string_literal: true

module Docs
  module Examples
    module Clipboard
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Clipboard.new do
            div(class: "row") do
              render PhlexKit::ClipboardSource.new { code { "gem install phlex_kit" } }
              render PhlexKit::ClipboardTrigger.new do
                render PhlexKit::Button.new(variant: :outline, size: :sm) { "Copy" }
              end
            end
          end
        end
      end
    end
  end
end
