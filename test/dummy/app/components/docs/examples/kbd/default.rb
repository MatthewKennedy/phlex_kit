# frozen_string_literal: true

module Docs
  module Examples
    module Kbd
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::KbdGroup.new do
            render PhlexKit::Kbd.new { "⌘" }
            render PhlexKit::Kbd.new { "⇧" }
            render PhlexKit::Kbd.new { "K" }
          end
          render PhlexKit::KbdGroup.new do
            render PhlexKit::Kbd.new { "Ctrl" }
            plain "+"
            render PhlexKit::Kbd.new { "B" }
          end
        end
      end
    end
  end
end
