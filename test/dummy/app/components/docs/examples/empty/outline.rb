# frozen_string_literal: true

module Docs
  module Examples
    module Empty
      class Outline < Phlex::HTML
        def view_template
          # The dashed border is opt-in via the `outline` modifier.
          render PhlexKit::Empty.new(class: "outline w-md") do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyMedia.new(variant: :icon) do
                render PhlexKit::Icon.new(:cloud, size: nil)
              end
              render PhlexKit::EmptyTitle.new { "Cloud Storage Empty" }
              render PhlexKit::EmptyDescription.new { "Upload files to your cloud storage to access them anywhere." }
            end
            render PhlexKit::EmptyContent.new do
              render PhlexKit::Button.new(variant: :outline, size: :sm) { "Upload Files" }
            end
          end
        end
      end
    end
  end
end
