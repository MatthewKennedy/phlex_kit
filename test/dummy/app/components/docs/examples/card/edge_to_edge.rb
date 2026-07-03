# frozen_string_literal: true

module Docs
  module Examples
    module Card
      class EdgeToEdge < Phlex::HTML
        # Negative margins of --pk-card-spacing take content edge to edge while
        # keeping it aligned with the card inset.
        def view_template
          render PhlexKit::Card.new(class: "w-md") do
            render PhlexKit::CardHeader.new do
              render PhlexKit::CardTitle.new { "Terms of Service" }
              render PhlexKit::CardDescription.new { "Review the terms before accepting the agreement." }
            end
            render PhlexKit::CardContent.new do
              div(style: "margin-inline: calc(-1 * var(--pk-card-spacing)); padding: var(--pk-card-spacing); border-block: 1px solid var(--pk-border); max-height: 8rem; overflow-y: auto") do
                div(class: "stack", style: "color: var(--pk-muted)") do
                  p(style: "margin:0") { "These terms govern your use of the workspace, including access to shared documents, project files, and collaboration tools." }
                  p(style: "margin:0") { "You are responsible for the content you upload and for ensuring that your team has the appropriate permissions to view or edit it." }
                  p(style: "margin:0") { "By continuing, you agree to keep your account credentials secure and to follow your organization's acceptable use policies." }
                end
              end
            end
            render PhlexKit::CardFooter.new(style: "justify-content: flex-end") do
              render PhlexKit::Button.new(variant: :outline, size: :sm) { "Decline" }
              render PhlexKit::Button.new(size: :sm) { "Accept" }
            end
          end
        end
      end
    end
  end
end
