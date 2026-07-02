module PhlexKit
  class BreadcrumbItem < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = li(**mix({ class: "pk-breadcrumb-item" }, @attrs), &)
  end
end
