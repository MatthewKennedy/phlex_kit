# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Destructive < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :destructive) { "Destructive" }
        end
      end
    end
  end
end
