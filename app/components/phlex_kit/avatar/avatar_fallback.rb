module PhlexKit
  # The fallback shown when a PhlexKit::Avatar has no image (or it fails to load) —
  # typically the user's initials. See avatar.rb.
  class AvatarFallback < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: "pk-avatar-fallback", data: { phlex_kit__avatar_target: "fallback" } }, @attrs), &block)
    end
  end
end
