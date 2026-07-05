# frozen_string_literal: true

module Docs
  module Examples
    module Kbd
      class Group < Phlex::HTML
        def view_template
          p(style: "font-size: .875rem; color: var(--pk-muted); margin: 0;") do
            plain "Use "
            render PhlexKit::KbdGroup.new do
              render PhlexKit::Kbd.new { "Ctrl + B" }
              render PhlexKit::Kbd.new { "Ctrl + K" }
            end
            plain " to open the command palette"
          end
        end
      end
    end
  end
end
