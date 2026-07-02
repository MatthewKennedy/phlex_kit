module PhlexKit
  class BreadcrumbList < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = ol(**mix({ class: "pk-breadcrumb-list" }, @attrs), &)
  end
end
