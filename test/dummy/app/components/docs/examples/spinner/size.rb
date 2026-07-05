# frozen_string_literal: true

module Docs
  module Examples
    module Spinner
      class Size < Phlex::HTML
        def view_template
          div(class: "row", style: "gap: 1.5rem") do
            render PhlexKit::Spinner.new(size: :sm)
            render PhlexKit::Spinner.new
            render PhlexKit::Spinner.new(size: :lg)
            render PhlexKit::Spinner.new(style: "width: 2rem; height: 2rem")
          end
        end
      end
    end
  end
end
