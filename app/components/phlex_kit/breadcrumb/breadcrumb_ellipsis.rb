module PhlexKit
  class BreadcrumbEllipsis < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      # No aria-hidden on the wrapper — it would swallow the sr-only text.
      # The Icon renders its own aria-hidden="true"; only the glyph is hidden.
      span(**mix({ class: "pk-breadcrumb-ellipsis", role: "presentation" }, @attrs)) do
        render Icon.new(:ellipsis, size: nil)
        span(class: "pk-sr-only") { "More" }
      end
    end
  end
end
