# frozen_string_literal: true

module Docs
  module Examples
    module Toast
      class Position < Phlex::HTML
        POSITIONS = [ "top-left", "top-center", "top-right", "bottom-left", "bottom-center", "bottom-right" ].freeze

        def view_template
          div(class: "row", style: "flex-wrap: wrap; justify-content: center;") do
            POSITIONS.each do |pos|
              render PhlexKit::Button.new(variant: :outline, onclick: safe("PhlexKit.toast('Event has been created', { position: '#{pos}' })")) do
                plain pos.split("-").map(&:capitalize).join(" ")
              end
            end
          end
        end
      end
    end
  end
end
