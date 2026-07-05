module PhlexKit
  # Trailing overflow pill in a PhlexKit::AvatarGroup ("+3", or a small svg),
  # ported from shadcn/ui's AvatarGroupCount. Sizes itself to match the
  # group's avatars via :has() in avatar.css. See avatar.rb.
  class AvatarGroupCount < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-avatar-group-count" }, @attrs), &block)
    end
  end
end
