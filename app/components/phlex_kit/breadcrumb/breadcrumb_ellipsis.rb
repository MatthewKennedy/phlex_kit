module PhlexKit
  class BreadcrumbEllipsis < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      span(**mix({ class: "pk-breadcrumb-ellipsis", role: "presentation", aria: { hidden: true } }, @attrs)) do
        svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "none", stroke: "currentColor", stroke_width: "2", stroke_linecap: "round", stroke_linejoin: "round") do |s|
          s.circle(cx: "12", cy: "12", r: "1")
          s.circle(cx: "19", cy: "12", r: "1")
          s.circle(cx: "5", cy: "12", r: "1")
        end
        span(class: "pk-sr-only") { "More" }
      end
    end
  end
end
