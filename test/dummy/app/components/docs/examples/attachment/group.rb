# frozen_string_literal: true

module Docs
  module Examples
    module Attachment
      class Group < Phlex::HTML
        FILES = [
          [ "briefing-notes.pdf", "PDF · 1.4 MB", "📄" ],
          [ "workspace.png", "PNG · 820 KB", "🖼" ],
          [ "customers.csv", "CSV · 18 KB", "📊" ],
          [ "renderer.tsx", "TSX · 12 KB", "📟" ],
          [ "quarterly-report.pdf", "PDF · 3.1 MB", "📄" ]
        ].freeze

        def view_template
          div(class: "w-md") do
            render PhlexKit::AttachmentGroup.new(aria: { label: "Attachments" }) do
              FILES.each do |name, meta, icon|
                render PhlexKit::Attachment.new do
                  render PhlexKit::AttachmentMedia.new { icon }
                  render PhlexKit::AttachmentContent.new do
                    render PhlexKit::AttachmentTitle.new { name }
                    render PhlexKit::AttachmentDescription.new { meta }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
