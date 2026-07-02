module PhlexKit
  # Placeholder shimmer for loading content. Ported from ruby_ui's RubyUI::Skeleton
  # (Tailwind `animate-pulse rounded-md bg-primary/10` → vanilla .pk-skeleton).
  class Skeleton < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)

    def view_template(&) = div(**mix({ class: "pk-skeleton" }, @attrs), &)
  end
end
