module PhlexKit
  # Status dot pinned to a PhlexKit::Avatar's bottom-right corner, ported from
  # shadcn/ui's AvatarBadge. Empty for a plain presence dot, or wrap a small
  # svg glyph (hidden automatically on xs/sm avatars). Recolor via style/class
  # — defaults to the brand fill. See avatar.rb.
  class AvatarBadge < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: "pk-avatar-badge" }, @attrs), &block)
    end
  end
end
