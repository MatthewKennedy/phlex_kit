# frozen_string_literal: true

module Docs
  module Examples
    module Badge
      class WithSpinner < Phlex::HTML
        def view_template
          div(class: "row") do
            render PhlexKit::Badge.new(variant: :destructive) do
              render PhlexKit::Spinner.new(data: { icon: "inline-start" })
              plain "Deleting"
            end
            render PhlexKit::Badge.new(variant: :secondary) do
              plain "Generating"
              render PhlexKit::Spinner.new(data: { icon: "inline-end" })
            end
          end
        end
      end
    end
  end
end
