module PhlexKit
  # Media slot of an Attachment: `variant: :icon` (default, a muted tile) or
  # `:image` (render an <img> inside; fills the slot, full-width when the
  # attachment is vertical). See attachment.rb.
  class AttachmentMedia < BaseComponent
    VARIANTS = { icon: nil, image: "image" }.freeze

    def initialize(variant: :icon, **attrs)
      @variant = variant.to_sym
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: [ "pk-attachment-media", VARIANTS.fetch(@variant) ].compact.join(" ") }, @attrs), &)
    end
  end
end
