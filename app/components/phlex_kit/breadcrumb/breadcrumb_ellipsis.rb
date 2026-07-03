module PhlexKit
  class BreadcrumbEllipsis < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      span(**mix({ class: "pk-breadcrumb-ellipsis", role: "presentation", aria: { hidden: true } }, @attrs)) do
        render Icon.new(:ellipsis, size: nil)
        span(class: "pk-sr-only") { "More" }
      end
    end
  end
end
