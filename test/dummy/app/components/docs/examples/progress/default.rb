# frozen_string_literal: true

module Docs
  module Examples
    module Progress
      class Default < Phlex::HTML
        def view_template
          div(style: "width: 60%") do
            render PhlexKit::Progress.new(value: 66)
          end
        end
      end
    end
  end
end
