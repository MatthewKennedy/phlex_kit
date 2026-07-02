module PhlexKit
  # File chip, ported from shadcn/ui's Attachment (an AI-chat-era addition, not
  # in ruby_ui): a bordered row of AttachmentMedia (icon or image preview) +
  # AttachmentContent(AttachmentTitle + AttachmentDescription) +
  # AttachmentActions(AttachmentAction — e.g. a remove ×).
  # `.pk-attachment*` (attachment.css).
  class Attachment < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-attachment" }, @attrs), &)
    end
  end
end
