# frozen_string_literal: true

module Docs
  module Examples
    module ShortcutKey
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::ShortcutKey.new { "⌘" }
          render PhlexKit::ShortcutKey.new { "K" }
        end
      end
    end
  end
end
