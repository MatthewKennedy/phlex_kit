module PhlexKit
  # Small ghost icon button in an Attachment (remove/download). Give it an
  # aria-label; block content is the icon (defaults to ×). See attachment.rb.
  class AttachmentAction < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      button(**mix({ type: :button, class: "pk-attachment-action" }, @attrs)) do
        if block
          yield
        else
          render Icon.new(:x, size: nil)
        end
      end
    end
  end
end
