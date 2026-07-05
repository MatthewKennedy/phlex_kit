# frozen_string_literal: true

module Docs
  module Examples
    module Input
      class Inline < Phlex::HTML
        def view_template
          div(class: "row w-sm") do
            render PhlexKit::Input.new(type: :search, placeholder: "Search...")
            render PhlexKit::Button.new { "Search" }
          end
        end
      end
    end
  end
end
