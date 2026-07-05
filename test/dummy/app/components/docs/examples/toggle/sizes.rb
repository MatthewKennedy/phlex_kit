# frozen_string_literal: true

module Docs
  module Examples
    module Toggle
      class Sizes < Phlex::HTML
        def view_template
          div(class: "row") do
            [ :sm, :default, :lg ].each do |size|
              render PhlexKit::Toggle.new(size: size, aria: { label: "Toggle #{size}" }) do
                render PhlexKit::Icon.new(:star, size: nil)
              end
            end
          end
        end
      end
    end
  end
end
