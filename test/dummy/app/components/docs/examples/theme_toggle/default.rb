# frozen_string_literal: true

module Docs
  module Examples
    module ThemeToggle
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::ThemeToggle.new { "🌓" }
        end
      end
    end
  end
end
