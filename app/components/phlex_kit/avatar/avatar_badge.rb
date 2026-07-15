module PhlexKit
  # Status dot pinned to a PhlexKit::Avatar's bottom-right corner, ported from
  # shadcn/ui's AvatarBadge. Empty for a plain presence dot, or wrap a small
  # svg glyph (hidden automatically on xs/sm avatars). Recolor via style/class
  # — defaults to the brand fill. See avatar.rb.
  class AvatarBadge < BaseComponent
    # label: gives the color-only presence dot an accessible alternative
    # (a .pk-sr-only span, like AttachmentAction's). No default — a purely
    # decorative dot stays silent.
    def initialize(label: nil, **attrs)
      @label = label
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: "pk-avatar-badge" }, @attrs)) do
        span(class: "pk-sr-only") { @label } if @label
        block&.call
      end
    end
  end
end
