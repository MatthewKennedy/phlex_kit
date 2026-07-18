module PhlexKit
  class BreadcrumbSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      li(**mix({ class: "pk-breadcrumb-separator", role: "presentation", aria: { hidden: "true" } }, @attrs)) do
        if block then yield else render(Icon.new(:chevron_right, size: nil)) end
      end
    end
  end
end
