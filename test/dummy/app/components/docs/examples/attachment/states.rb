# frozen_string_literal: true

module Docs
  module Examples
    module Attachment
      class States < Phlex::HTML
        STATES = [
          [ :idle, "selected-file.pdf", "Ready to upload", "📄" ],
          [ :uploading, "design-system.zip", "Uploading · 64%", "🗜" ],
          [ :processing, "market-research.pdf", "Processing document", "⏳" ],
          [ :error, "financial-model.xlsx", "Upload failed. Try again.", "⚠" ],
          [ :done, "uploaded-report.pdf", "Uploaded · 1.8 MB", "✓" ]
        ].freeze

        def view_template
          div(class: "stack w-md") do
            STATES.each do |state, name, meta, icon|
              render PhlexKit::Attachment.new(state: state) do
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
