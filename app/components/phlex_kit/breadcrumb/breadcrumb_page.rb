module PhlexKit
  class BreadcrumbPage < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      span(**mix({ class: "pk-breadcrumb-page", role: "link", aria: { disabled: "true", current: "page" } }, @attrs), &)
    end
  end
end
