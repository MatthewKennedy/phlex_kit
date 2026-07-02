# frozen_string_literal: true

module Docs
  module Examples
    module Progress
      class Default < Phlex::HTML
        def view_template
          div(class: "stack w-md") do
            render PhlexKit::Progress.new(value: 13)
            render PhlexKit::Progress.new(value: 66)
          end
        end
      end
    end
  end
end
