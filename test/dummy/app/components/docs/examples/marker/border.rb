# frozen_string_literal: true

module Docs
  module Examples
    module Marker
      class Border < Phlex::HTML
        ROWS = [
          [ :code, "Switched to release-candidate" ],
          [ :search, "Reviewed 8 related files" ],
          [ :file, "Opened implementation notes" ]
        ].freeze

        def view_template
          div(class: "stack w-sm", style: "gap: .75rem; padding: 2rem 0;") do
            ROWS.each do |icon, text|
              render PhlexKit::Marker.new(variant: :border) do
                render PhlexKit::MarkerIcon.new { render PhlexKit::Icon.new(icon, size: nil) }
                render PhlexKit::MarkerContent.new { text }
              end
            end
          end
        end
      end
    end
  end
end
