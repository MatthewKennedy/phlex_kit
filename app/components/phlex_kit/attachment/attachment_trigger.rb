module PhlexKit
  # Full-card overlay that activates the attachment (a preview link or dialog
  # trigger). Sits BEHIND AttachmentActions in the stacking order, so actions
  # stay independently clickable. Give it an aria-label; pass `as: :a` +
  # `href:` for a link. See attachment.rb.
  class AttachmentTrigger < BaseComponent
    def initialize(as: :button, href: nil, **attrs)
      @as = as.to_sym
      @href = href
      @attrs = attrs
    end

    def view_template
      base = { class: "pk-attachment-trigger" }
      if @as == :a
        a(**mix(base.merge(href: @href), @attrs))
      else
        button(**mix(base.merge(type: :button), @attrs))
      end
    end
  end
end
