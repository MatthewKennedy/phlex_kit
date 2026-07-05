# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class SpinnerDemo < Phlex::HTML
        def view_template
          div(class: "row") do
            render PhlexKit::Button.new(variant: :outline, disabled: true) do
              render PhlexKit::Spinner.new(data: { icon: "inline-start" })
              plain "Generating"
            end
            render PhlexKit::Button.new(variant: :secondary, disabled: true) do
              plain "Downloading"
              render PhlexKit::Spinner.new(data: { icon: "inline-end" })
            end
          end
        end
      end
    end
  end
end
