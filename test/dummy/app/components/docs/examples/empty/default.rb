# frozen_string_literal: true

module Docs
  module Examples
    module Empty
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Empty.new(class: "w-md") do
            render PhlexKit::EmptyHeader.new do
              render PhlexKit::EmptyMedia.new(variant: :icon) do
                render PhlexKit::Icon.new(:folder, size: nil)
              end
              render PhlexKit::EmptyTitle.new { "No Projects Yet" }
              render PhlexKit::EmptyDescription.new { "You haven't created any projects yet. Get started by creating your first project." }
            end
            render PhlexKit::EmptyContent.new(style: "flex-direction: row; justify-content: center; gap: .5rem;") do
              render PhlexKit::Button.new { "Create Project" }
              render PhlexKit::Button.new(variant: :outline) { "Import Project" }
            end
            render PhlexKit::Button.new(variant: :link, size: :sm, href: "#", style: "color: var(--pk-muted)") do
              plain "Learn More "
              render PhlexKit::Icon.new(:external_link, size: nil, data: { icon: "inline-end" })
            end
          end
        end
      end
    end
  end
end
