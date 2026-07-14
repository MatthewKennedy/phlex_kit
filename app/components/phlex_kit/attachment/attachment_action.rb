module PhlexKit
  # Small ghost icon button in an Attachment (remove/download). Block content
  # is the icon (defaults to ×). `label:` renders a pk-sr-only span so the
  # icon-only button always has an accessible name (default "Remove") —
  # override it per action, or pass `label: nil` when supplying your own
  # aria-label. See attachment.rb.
  class AttachmentAction < BaseComponent
    def initialize(label: "Remove", **attrs)
      @label = label
      @attrs = attrs
    end

    def view_template(&block)
      button(**mix({ type: :button, class: "pk-attachment-action" }, @attrs)) do
        if block
          yield
        else
          render Icon.new(:x, size: nil)
        end
        span(class: "pk-sr-only") { @label } if @label
      end
    end
  end
end
