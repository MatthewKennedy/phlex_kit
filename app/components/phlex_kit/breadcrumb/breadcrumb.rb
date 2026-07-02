module PhlexKit
  # Navigational hierarchy trail. Ported from ruby_ui's RubyUI::Breadcrumb. Compose
  # Breadcrumb > BreadcrumbList > BreadcrumbItem (+ Link/Page/Separator/Ellipsis).
  class Breadcrumb < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = nav(**mix({ class: "pk-breadcrumb", aria: { label: "breadcrumb" } }, @attrs), &)
  end
end
