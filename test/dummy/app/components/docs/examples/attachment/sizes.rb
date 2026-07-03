# frozen_string_literal: true

module Docs
  module Examples
    module Attachment
      class Sizes < Phlex::HTML
        def view_template
          div(class: "stack w-md") do
            render PhlexKit::Attachment.new do
              render PhlexKit::AttachmentMedia.new { "📄" }
              render PhlexKit::AttachmentContent.new do
                render PhlexKit::AttachmentTitle.new { "Default attachment" }
                render PhlexKit::AttachmentDescription.new { "PDF · 2.4 MB" }
              end
            end
            render PhlexKit::Attachment.new(size: :sm) do
              render PhlexKit::AttachmentMedia.new { "📄" }
              render PhlexKit::AttachmentContent.new do
                render PhlexKit::AttachmentTitle.new { "Small attachment" }
                render PhlexKit::AttachmentDescription.new { "PDF · 2.4 MB" }
              end
            end
            render PhlexKit::Attachment.new(size: :xs) do
              render PhlexKit::AttachmentMedia.new { "📄" }
              render PhlexKit::AttachmentContent.new do
                render PhlexKit::AttachmentTitle.new { "Extra small attachment" }
              end
            end
          end
        end
      end
    end
  end
end
