module PhlexKit
  # Navigational hierarchy trail. Ported from ruby_ui's RubyUI::Breadcrumb. Compose
  # Breadcrumb > BreadcrumbList > BreadcrumbItem (+ Link/Page/Separator/Ellipsis).
  class Breadcrumb < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)

    def view_template(&)
      base = { class: "pk-breadcrumb" }
      # Default only when the caller didn't supply their own accessible name
      # (localization, two breadcrumbs on a page) — `mix` would fuse them.
      base[:aria] = { label: "breadcrumb" } unless aria_labelled?
      nav(**mix(base, @attrs), &)
    end
  end
end
