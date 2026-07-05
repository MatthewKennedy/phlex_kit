module PhlexKit
  # Avatar, ported from ruby_ui's RubyUI::Avatar — a round image with a fallback
  # (initials), matched to shadcn/ui's current avatar. Keeps ruby_ui's
  # `phlex-kit--avatar` Stimulus controller (shows the image once it loads, else
  # the fallback). Compose AvatarImage + AvatarFallback (+ optional AvatarBadge
  # status dot); fallback-only is fine (the controller no-ops without an image).
  # Overlap several in an AvatarGroup, with AvatarGroupCount as the "+3" pill.
  # shadcn ships sm/default/lg; xs/xl are kit extras. `SIZES.fetch` fails loud.
  class Avatar < BaseComponent
    SIZES = { xs: "xs", sm: "sm", md: nil, lg: "lg", xl: "xl" }.freeze

    def initialize(size: :md, **attrs)
      @size = size.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      span(**mix({ class: classes, data: { controller: "phlex-kit--avatar" } }, @attrs), &block)
    end

    private

    def classes
      [ "pk-avatar", SIZES.fetch(@size) ].compact.join(" ")
    end
  end
end
