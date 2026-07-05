# frozen_string_literal: true

module Docs
  module Examples
    module Message
      class WithAttachment < Phlex::HTML
        def view_template
          div(class: "stack w-sm", style: "gap: 1.5rem; padding: 2rem 0;") do
            render PhlexKit::Message.new(align: :end) do
              render PhlexKit::MessageContent.new do
                render PhlexKit::Attachment.new do
                  render PhlexKit::AttachmentMedia.new do
                    render PhlexKit::Icon.new(:file, size: nil)
                  end
                  render PhlexKit::AttachmentContent.new do
                    render PhlexKit::AttachmentTitle.new { "quarterly-report.pdf" }
                    render PhlexKit::AttachmentDescription.new { "2.4 MB" }
                  end
                  render PhlexKit::AttachmentActions.new do
                    render PhlexKit::Button.new(variant: :ghost, size: :xs, icon: true, aria: { label: "Download" }) do
                      render PhlexKit::Icon.new(:download, size: nil)
                    end
                  end
                end
                render PhlexKit::Bubble.new do
                  render PhlexKit::BubbleContent.new { "Here's the quarterly report you asked for." }
                end
              end
            end
          end
        end
      end
    end
  end
end
