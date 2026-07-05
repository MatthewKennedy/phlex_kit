# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Ghost < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :ghost) { "Ghost" }
        end
      end
    end
  end
end
