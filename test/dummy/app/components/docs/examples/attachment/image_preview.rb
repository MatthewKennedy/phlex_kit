# frozen_string_literal: true

module Docs
  module Examples
    module Attachment
      class ImagePreview < Phlex::HTML
        def view_template
          div(class: "w-md") do
            render PhlexKit::Attachment.new do
              render PhlexKit::AttachmentMedia.new do
                img(src: "https://i.pravatar.cc/80?img=5", alt: "")
              end
              render PhlexKit::AttachmentContent.new do
                render PhlexKit::AttachmentTitle.new { "team-photo.jpg" }
                render PhlexKit::AttachmentDescription.new { "JPG · 640 KB" }
              end
              render PhlexKit::AttachmentActions.new do
                render PhlexKit::AttachmentAction.new(aria: { label: "Remove team-photo.jpg" })
              end
            end
          end
        end
      end
    end
  end
end
