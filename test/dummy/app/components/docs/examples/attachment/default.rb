# frozen_string_literal: true

module Docs
  module Examples
    module Attachment
      class Default < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::Attachment.new do
              render PhlexKit::AttachmentMedia.new { "📄" }
              render PhlexKit::AttachmentContent.new do
                render PhlexKit::AttachmentTitle.new { "sales-dashboard.pdf" }
                render PhlexKit::AttachmentDescription.new { "PDF · 2.4 MB" }
              end
              render PhlexKit::AttachmentActions.new do
                render PhlexKit::AttachmentAction.new(aria: { label: "Remove sales-dashboard.pdf" })
              end
            end
          end
        end
      end
    end
  end
end
