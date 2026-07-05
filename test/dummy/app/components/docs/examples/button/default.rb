# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Button.new { "Button" }
        end
      end
    end
  end
end
