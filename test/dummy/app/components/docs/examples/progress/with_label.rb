# frozen_string_literal: true

module Docs
  module Examples
    module Progress
      class WithLabel < Phlex::HTML
        def view_template
          render PhlexKit::Field.new(class: "w-sm") do
            render PhlexKit::FieldLabel.new(for: "progress-upload", style: "width: 100%") do
              span { "Upload progress" }
              span(style: "margin-left: auto; color: var(--pk-muted); font-variant-numeric: tabular-nums;") { "66%" }
            end
            render PhlexKit::Progress.new(value: 66, id: "progress-upload")
          end
        end
      end
    end
  end
end
