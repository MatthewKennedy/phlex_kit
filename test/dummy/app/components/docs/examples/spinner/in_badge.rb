# frozen_string_literal: true

module Docs
  module Examples
    module Spinner
      class InBadge < Phlex::HTML
        def view_template
          div(class: "row") do
            render PhlexKit::Badge.new do
              render PhlexKit::Spinner.new(data: { icon: "inline-start" })
              plain "Syncing"
            end
            render PhlexKit::Badge.new(variant: :secondary) do
              plain "Indexing"
              render PhlexKit::Spinner.new(data: { icon: "inline-end" })
            end
          end
        end
      end
    end
  end
end
