module PhlexKit
  # Small ghost icon button in an Attachment (remove/download). Give it an
  # aria-label; block content is the icon (defaults to ×). See attachment.rb.
  class AttachmentAction < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      button(**mix({ type: :button, class: "pk-attachment-action" }, @attrs)) do
        if block
          yield
        else
          svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "none",
              stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round",
              "stroke-linejoin": "round", "aria-hidden": "true") do |s|
            s.path(d: "M18 6 6 18")
            s.path(d: "m6 6 12 12")
          end
        end
      end
    end
  end
end
