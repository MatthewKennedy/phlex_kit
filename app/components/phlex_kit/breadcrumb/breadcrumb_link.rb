module PhlexKit
  class BreadcrumbLink < BaseComponent
    def initialize(href: "#", **attrs)
      @href = href
      @attrs = attrs
    end
    def view_template(&) = a(**mix({ href: @href, class: "pk-breadcrumb-link" }, @attrs), &)
  end
end
