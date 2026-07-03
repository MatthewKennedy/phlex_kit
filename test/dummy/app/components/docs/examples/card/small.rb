# frozen_string_literal: true

module Docs
  module Examples
    module Card
      class Small < Phlex::HTML
        def view_template
          render PhlexKit::Card.new(size: :sm, class: "w-md") do
            render PhlexKit::CardHeader.new do
              render PhlexKit::CardTitle.new { "Small Card" }
              render PhlexKit::CardDescription.new { "This card uses the small size variant." }
              render PhlexKit::CardAction.new do
                render PhlexKit::Button.new(size: :sm, variant: :outline) { "Action" }
              end
            end
            render PhlexKit::CardContent.new do
              plain "The card component supports a size: option that can be set to :sm for a more compact appearance."
            end
          end
        end
      end
    end
  end
end
