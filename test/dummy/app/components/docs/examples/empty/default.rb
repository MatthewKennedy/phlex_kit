# frozen_string_literal: true

module Docs
  module Examples
    module Empty
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Empty.new(class: "w-md") do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyMedia.new { "📁" }
              render PhlexKit::EmptyTitle.new { "No projects yet" }
              render PhlexKit::EmptyDescription.new { "You haven't created any projects. Get started by creating your first one." }
            end
            render PhlexKit::EmptyContent.new do
              render PhlexKit::Button.new(size: :sm) { "Create project" }
              render PhlexKit::Button.new(size: :sm, variant: :outline) { "Import" }
            end
          end
        end
      end
    end
  end
end
