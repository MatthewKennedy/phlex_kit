# frozen_string_literal: true

module Docs
  module Examples
    module Icon
      class Default < Phlex::HTML
        def view_template
          div(style: "display:flex;align-items:center;gap:1rem") do
            render PhlexKit::Icon.new(:check)
            render PhlexKit::Icon.new(:calendar)
            render PhlexKit::Icon.new(:search, size: 20)
            render PhlexKit::Icon.new(:settings, size: 24)
            render PhlexKit::Icon.new(:heart, size: 24, style: "color: var(--pk-red)")
            render PhlexKit::Button.new(variant: :outline) do
              render PhlexKit::Icon.new(:download)
              plain " Download"
            end
          end
        end
      end
    end
  end
end
