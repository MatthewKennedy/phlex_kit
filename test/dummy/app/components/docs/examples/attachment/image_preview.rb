# frozen_string_literal: true

module Docs
  module Examples
    module Attachment
      class ImagePreview < Phlex::HTML
        FILES = [
          [ "workspace.png", "PNG · 820 KB", 12 ],
          [ "desk-reference.jpg", "JPG · 1.1 MB", 22 ],
          [ "office-reference.jpg", "JPG · 940 KB", 32 ]
        ].freeze

        def view_template
          FILES.each do |name, meta, img|
            render PhlexKit::Attachment.new(orientation: :vertical) do
              render PhlexKit::AttachmentMedia.new(variant: :image) do
                img(src: "https://picsum.photos/id/#{img}/320/240", alt: "")
              end
              render PhlexKit::AttachmentContent.new do
                render PhlexKit::AttachmentTitle.new { name }
                render PhlexKit::AttachmentDescription.new { meta }
              end
              render PhlexKit::AttachmentActions.new do
                render PhlexKit::AttachmentAction.new(aria: { label: "Remove #{name}" })
              end
            end
          end
        end
      end
    end
  end
end
