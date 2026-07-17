# frozen_string_literal: true

module Docs
  module Examples
    module Progress
      class Indeterminate < Phlex::HTML
        def view_template
          # value: nil — unknown completion; a segment sweeps the track.
          div(style: "width: 60%") do
            render PhlexKit::Progress.new(value: nil, value_text: "Loading…")
          end
        end
      end
    end
  end
end
