module PhlexKit
  # Full-card overlay that activates the attachment (a preview link or dialog
  # trigger). Sits BEHIND AttachmentActions in the stacking order, so actions
  # stay independently clickable. Give it an aria-label; pass `as: :a` +
  # `href:` for a link. See attachment.rb.
  class AttachmentTrigger < BaseComponent
    AS_TAGS = %i[button a].freeze

    def initialize(as: :button, href: nil, **attrs)
      @as = as.to_sym
      unless AS_TAGS.include?(@as)
        raise ArgumentError, "unknown AttachmentTrigger as: #{@as.inspect} (use one of #{AS_TAGS.join(", ")})"
      end
      @href = href
      @attrs = attrs
    end

    def view_template(&block)
      base = { class: "pk-attachment-trigger" }
      if @as == :a
        a(**mix(base.merge(href: @href), @attrs), &block)
      else
        button(**mix(base.merge(type: :button), @attrs), &block)
      end
    end
  end
end
