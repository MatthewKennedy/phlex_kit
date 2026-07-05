# frozen_string_literal: true

module Docs
  module Examples
    module Progress
      class WithLabel < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: .5rem") do
            render PhlexKit::Label.new(for: "progress-upload", style: "display: flex; width: 100%;") do
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
