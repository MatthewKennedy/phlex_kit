# frozen_string_literal: true

module Docs
  module Examples
    module Attachment
      class Trigger < Phlex::HTML
        # The trigger fills the card behind the actions, so the actions stay
        # independently clickable — click the card body vs the ×.
        def view_template
          div(class: "w-md") do
            render PhlexKit::Attachment.new do
              render PhlexKit::AttachmentMedia.new { "🔍" }
              render PhlexKit::AttachmentContent.new do
                render PhlexKit::AttachmentTitle.new { "research-summary.pdf" }
                render PhlexKit::AttachmentDescription.new { "Open preview" }
              end
              render PhlexKit::AttachmentActions.new do
                render PhlexKit::AttachmentAction.new(aria: { label: "Remove research-summary.pdf" })
              end
              render PhlexKit::AttachmentTrigger.new(
                as: :a, href: "#attachment", aria: { label: "Preview research-summary.pdf" }
              )
            end
          end
        end
      end
    end
  end
end
