# frozen_string_literal: true

module Docs
  module Examples
    module Spinner
      class InButton < Phlex::HTML
        def view_template
          div(class: "row") do
            render PhlexKit::Button.new(disabled: true) do
              render PhlexKit::Spinner.new(data: { icon: "inline-start" })
              plain "Loading..."
            end
            render PhlexKit::Button.new(variant: :outline, disabled: true) do
              render PhlexKit::Spinner.new(data: { icon: "inline-start" })
              plain "Please wait"
            end
          end
        end
      end
    end
  end
end
