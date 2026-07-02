module PhlexKit
  class BreadcrumbSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      li(**mix({ class: "pk-breadcrumb-separator", role: "presentation", aria: { hidden: true } }, @attrs)) do
        if block then yield else svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "none", stroke: "currentColor", stroke_width: "2", stroke_linecap: "round", stroke_linejoin: "round") { |s| s.path(d: "m9 18 6-6-6-6") } end
      end
    end
  end
end
