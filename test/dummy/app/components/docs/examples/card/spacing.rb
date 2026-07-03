# frozen_string_literal: true

module Docs
  module Examples
    module Card
      class Spacing < Phlex::HTML
        # Every gap and inset derives from --pk-card-spacing — set it inline.
        def view_template
          { "16px" => "1rem", "24px" => "1.5rem", "32px" => "2rem" }.each do |label, spacing|
            render PhlexKit::Card.new(class: "w-sm", style: "--pk-card-spacing: #{spacing}") do
              render PhlexKit::CardHeader.new do
                render PhlexKit::CardTitle.new { label }
                render PhlexKit::CardDescription.new { "--pk-card-spacing: #{spacing}" }
              end
              render PhlexKit::CardContent.new { "Sections and insets follow." }
            end
          end
        end
      end
    end
  end
end
